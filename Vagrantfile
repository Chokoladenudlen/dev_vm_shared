# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

# New user? Enter your details here 👇 Or use a .vagrantuser file, which will
# will take precedence over this section
  config.user.defaults = {
    "user" => "user",
    "pwd" => "password",
    "fullname" => "Player the First",
    "email" => "user@example.com",
    "sshkey" => "c:/Users/user/.ssh/id",
    "vars" => {}
  }

  config.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04
  config.vm.hostname = "ABC"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = 8192
    vb.gui = true
  # 8 linjer vb.customize hapset fra GP:
    vb.customize ["modifyvm", :id, "--vram", "128"] # 128 MB Video Memory
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']  # Graphics: https://superuser.com/a/1403131/1190637
    vb.customize ['modifyvm', :id, '--accelerate3d', 'on'] # Enable 3D Acceleration
    vb.customize ["modifyvm", :id, "--usb", "on"] # Enable USB
    vb.customize ["modifyvm", :id, "--usbxhci", "on"] # Enable USB3
  end

  config.vm.disk :disk, size: "200GB", primary: true  # Kræver VAGRANT_EXPRIMENTAL="disks" i miljøvariabler

  config.vbguest.auto_update = false

# Provision with Ansible (https://www.vagrantup.com/docs/provisioning/ansible_local)
  config.vm.provision "ansible_local" do |ansible|
    ansible.galaxy_role_file = 'src/ansible/ansible_galaxy_roles.yaml'
    ansible.playbook = "src/ansible/ansible_playbooks.yaml"  # if missing, create from ansible_playbooks_template.yaml
    ansible.provisioning_path = "/vagrant/"
    ansible.extra_vars = {
      user: config.user.user,
      pwd: config.user.pwd,
      fullname: config.user.fullname,
      email: config.user.email,
      sshkey: File.basename(config.user.sshkey)
    }
    # ansible.tags="test"  # only runs these tags, unless outcommented
    # ansible.verbose = "vv"
  end


# Copy SSH key to VM
# Ansible_local can't access host SSH key on host; we must copy it another way
  config.vm.provision "file", source: config.user.sshkey, destination: "/tmp/"
  config.vm.provision "shell", after: "ansible_local", path: "./src/shell/ssh_move_key.sh",
    args: [config.user.user, File.basename(config.user.sshkey)]
    # note on 'after': https://developer.hashicorp.com/vagrant/docs/provisioning/basic_usage#after


# Mount shared folders between host & VM
# NOTE: Outcomment when building VM, uncomment on later runs
  config.vm.synced_folder "c:/kode", "/kode/",
  owner: config.user.user, group: config.user.user

end
