BOOT2DOCKER_VERSION = 1.8.1
DOCKER_COMPOSE_VERSION = 1.4.0
MACHINE_NAME = b2d-vagrant

all: clean build test

build: boot2docker.iso
	# Create and alter a B2B VM.
	docker-machine create --driver=virtualbox $(MACHINE_NAME)
	# Download docker-compose to permanent storage.
	docker-machine ssh $(MACHINE_NAME) 'sudo curl -L https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-`uname -s`-`uname -m` --create-dirs -o /var/lib/boot2docker/bin/docker-compose'
	# Run provisioning script.
	docker-machine ssh $(MACHINE_NAME) < scripts/provision.sh
	# Restart VM to apply settings.
	docker-machine restart $(MACHINE_NAME)
	# Detach boot2docker.iso from the VM.
	VBoxManage storageattach $(MACHINE_NAME) --storagectl SATA --port 0 --medium emptydrive
	# Export VM into a Vagrant base box.
	vagrant package --base $(MACHINE_NAME) --vagrantfile Vagrantfile --include boot2docker.iso --output boot2docker_virtualbox.box
	# Remove VM
	docker-machine rm $(MACHINE_NAME)

boot2docker.iso:
	curl -L -o boot2docker.iso https://github.com/boot2docker/boot2docker/releases/download/v$(BOOT2DOCKER_VERSION)/boot2docker.iso

test:
	@cd tests/virtualbox; bats --tap *.bats

clean:
	rm -rf *.iso *.box
	docker-machine rm -f $(MACHINE_NAME) || true

.PHONY: clean build test all
