#!/usr/bin/env bats

# Given i'm already in a Vagrantfile-ized folder
# And the basebox has already been added to vagrant

@test "We can vagrant up the VM with basic settings" {
	# Ensure we start clean
	run vagrant destroy -f
	cp -f Vagrantfile.template Vagrantfile
	vagrant up
	[ $( vagrant status | grep 'running' | wc -l ) -ge 1 ]
}

@test "Vagrant can ssh to the VM" {
	vagrant ssh -c 'echo OK'
}

@test "We can sftp to the VM" {
	vagrant ssh-config > ssh_config
	host=$(grep 'Host ' ssh_config | cut -d ' ' -f 2)
	echo 'pwd' | sftp -F ssh_config $host
}

@test "Default ssh user has sudoers rights" {
	[ "$(vagrant ssh -c 'sudo whoami' -- -n -T)" == "root" ]
}

@test "Docker client exists in the remote VM" {
	vagrant ssh -c 'which docker'
}

@test "Docker is working inside the remote VM " {
	vagrant ssh -c 'docker ps'
}

@test "Docker is version DOCKER_TARGET_VERSION=${DOCKER_TARGET_VERSION}" {
	DOCKER_VERSION=$(vagrant ssh -c "docker version --format '{{.Server.Version}}'" -- -n -T)
	[ "${DOCKER_VERSION}" == "${DOCKER_TARGET_VERSION}" ]
}

@test "Docker Compose is version COMPOSE_TARGET_VERSION=${COMPOSE_TARGET_VERSION}" {
	COMPOSE_VERSION=$(vagrant ssh -c "docker-compose version --short" -- -n -T)
	[ "${COMPOSE_VERSION}" == "${COMPOSE_TARGET_VERSION}" ]
}

@test "We can reboot the VM properly" {
	vagrant reload
	vagrant ssh -c 'echo OK'
}

@test "Rsync is installed inside the b2d" {
	vagrant ssh -c "which rsync"
}

@test "The NFS client is started inside the VM" {
	[ $( vagrant ssh -c 'ps aux | grep rpc.statd | wc -l' -- -n -T ) -ge 4 ]
}

@test "We can share folder thru rsync" {
	sed 's/#SYNC_TOKEN/config.vm.synced_folder ".", "\/vagrant", type: "rsync"/g' Vagrantfile.template | tee Vagrantfile
	vagrant reload
	[ $( vagrant status | grep 'running' | wc -l ) -ge 1 ]
	vagrant ssh -c "ls -l /vagrant/Vagrantfile"
}

@test "I can stop the VM" {
	vagrant halt
}

@test "I can destroy and clean the VM" {
	vagrant destroy -f
}
