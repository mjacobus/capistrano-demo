# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 9000
  config.vm.hostname = "capistrano-demo"
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vm|
    vm.name = "capistrano-demo"
    vm.memory = '1024'
  end

  config.vm.provision :shell, path: './vagrant/setup.sh'
end
