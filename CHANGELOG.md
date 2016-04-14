# Changelog

## v1.11.0 (2016-04-14)

- Built with docker-machine 0.7.0
- Versions: boot2docker/docker 1.11.0, docker-compose 1.7.0


## v1.10.3 (2016-03-31)

- Built with docker-machine 0.7.0-rc1
- Versions: boot2docker/docker 1.10.3, docker-compose 1.6.2
- Misc fixes


## v1.9.1-overlay (2016-01-08)

- Built with docker-machine v0.5.5
- Version: docker v1.9.1, docker-compose v1.5.2
- Changes:
  - Symlink /Users and /cygdrive to the VMs permanent storage
  - Switch to the overlay driver (experimental)


## v1.9.1 (2016-01-08)

- Built with docker-machine v0.5.5
- Version: docker v1.9.1, docker-compose v1.5.2
- Changes:
  - Symlink /Users and /cygdrive to the VMs permanent storage


## v1.9.0 (2015-11-06)

- Buil with Docker Machine v0.5.0
- Boot2docker/Docker v1.9.0, Docker Compose v1.5.0
- Fixed tests: Disable vagrant-gatling-rsync autostart if installed


## v1.8.3 (2015-10-25)

- Boot2docker/Docker v1.8.3
- Docker Compose v1.4.2
- Use a different tiny core mirror (since the primary repo is down)
- Enable SFTP support
- Start NFS client utilities at boot


## v1.8.2 (2015-09-29)

- Boot2docker/Docker 1.8.2
- Docker Compose 1.4.2
- DNS discovery ready


## v1.8.1 (2015-08-18)

- Boot2docker/Docker 1.8.1
- Docker Compose 1.4.0


## v1.7.1 (2015-07-17)

- Boot2docker/Docker 1.7.1
- Docker Compose 1.3.3
- Fix compatibility with VirtualBox 5
- Removed custom rsync binary - now available from the TinyCore repo


## v1.7.1 (2015-07-17)

- Boot2docker/Docker 1.7.1


## v1.7.0 (2015-06-24)

- Boot2docker/Docker 1.7.0


## v1.6.2 (2015-06-09)

- Boot2docker/Docker 1.6.2
- Switching to `virtio` for networking