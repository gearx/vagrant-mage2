# -*- mode: ruby -*-
# vi: set ft=ruby :


required_plugins = %w( vagrant-vbguest vagrant-hostsupdater nugrant )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end


Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Default settings.  Can be overridden in .vagrantuser file (nugrant plugin)
  config.user.defaults = {
    'extra_synced_folders' => {},
    'memory' => 4096
  }

  # Every Vagrant virtual environment requires a box to build off of.
  # Our custom gearx/lamp base box has replaced ubuntu/trusty64.
  config.vm.box = "bento/ubuntu-16.04"

  config.vbguest.auto_update = false

  config.vm.define "mage2" do |mage2|
  end
  
  config.vm.provision "install",  type: "shell",  path: "vagrant/install.sh"
  config.vm.provision "config",   type: "shell",  path: "vagrant/config.sh"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Required for NFS to work, pick any local IP
  config.vm.network :private_network, ip: '192.168.50.70'

  config.vm.hostname = "mage2.local"
  config.hostsupdater.remove_on_suspend = false


  config.vm.synced_folder ".", "/var/www/html", type: "nfs"

  config.user.extra_synced_folders.each do |host, guest|
    config.vm.synced_folder "#{host}", "#{guest}", type: "nfs"
  end

  config.ssh.forward_agent = true

  # It's tempting to assign more than one cpu, but DON'T DO IT!!  Multiple cpus
  # will slow down the VM due to the way VirtualBox processor scheduling works.
  # http://www.mihaimatei.com/virtualbox-performance-issues-multiple-cpu-cores/

  config.vm.provider "virtualbox" do |vb|
    vb.memory = config.user.memory
    vb.cpus = 1
    vb.name = "vagrant-mage2"
  end

end




