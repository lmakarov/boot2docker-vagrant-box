Vagrant.configure("2") do |config|
  config.ssh.shell = "sh"
  config.ssh.username = "docker"

  # Used on Vagrant >= 1.7.x to disable the ssh key regeneration
  config.ssh.insert_key = false

  # Attach boot2docker.iso
  config.vm.provider "virtualbox" do |v|
    v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 0, '--device', 0, '--type', 'dvddrive', '--medium', File.expand_path("../boot2docker.iso", __FILE__)]
  end

  # Expose the Docker ports
  config.vm.network "forwarded_port", guest: 2375, host: 2375, host_ip: "127.0.0.1", auto_correct: true, id: "docker"
  config.vm.network "forwarded_port", guest: 2376, host: 2376, host_ip: "127.0.0.1", auto_correct: true, id: "docker-tls"
end
