DOCKER_MACHINE_VERSION = 0.5.5
BOOT2DOCKER_VERSION = 1.9.1
DOCKER_COMPOSE_VERSION = 1.5.2
MACHINE_NAME = b2d-vagrant

all: docker-machine clean boot2docker.iso build test

build:
	# Create and alter a B2B VM.
	docker-machine create --driver=virtualbox --virtualbox-boot2docker-url=file://`pwd`/boot2docker.iso $(MACHINE_NAME)
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
	docker-machine rm -f $(MACHINE_NAME)

docker-machine:
	# Install the specific docker-machine version
	curl -L https://github.com/docker/machine/releases/download/v$(DOCKER_MACHINE_VERSION)/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
	chmod +x /usr/local/bin/docker-machine

boot2docker.iso:
	curl -L https://github.com/boot2docker/boot2docker/releases/download/v$(BOOT2DOCKER_VERSION)/boot2docker.iso -o boot2docker.iso

test:
	@cd tests/virtualbox; \
	DOCKER_TARGET_VERSION=$(BOOT2DOCKER_VERSION) \
	COMPOSE_TARGET_VERSION=$(DOCKER_COMPOSE_VERSION) \
	bats --tap *.bats

clean:
	rm -rf *.iso *.box
	docker-machine rm -f $(MACHINE_NAME) || true

.PHONY: clean build test all
