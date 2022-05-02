# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"
    (1..3).each do |i|
      config.vm.define vm_name = "hci-#{i}" do |config|
        config.vm.hostname = vm_name
        config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
        config.vm.provision "shell", inline: <<-SHELL
            cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
        SHELL
        ip = "192.168.55.#{i+10}"
        config.vm.network :private_network, ip: ip
        config.vm.provider :libvirt do |libvirt|
          libvirt.storage :file, :size => '100G'
          libvirt.cpu_mode = 'host-passthrough'
          libvirt.cpus = 4
          libvirt.nested = true
          libvirt.memory = '4096'
        end
      end
    end
  end