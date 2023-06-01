# 💻🐧Dev VM 

A Vagrant recipe for creating a Ubuntu VM in VirtualBox. It creates a user for you, copies over your ssh key, and installs . This is done using Vagrant, Ansible ("local", i.e. inside the VM; you can run this from Windows), and a few shellscripts.

Use at your own peril and pleasure.

-Martin

## ✅Requirements

Your host needs,
* Vagrant
* VirtualBox
* internet connection during installation

I've had functionality break, to the point that the VM couldn't start, at two separate occasions after VirtualBox was updated. So I'm not going to presume to know which versions work together. I'll just note, that per 2013-01-18, I have `Vagrant 2.3.2` and `VirtualBox 7.0.2`running on `Windows 11 Pro 22H2`, and things currently *"work on my computer"*, as the useless saying goes.

Let it be noted, that I also currently have the following vagrant plugins
```
nugrant (2.1.3, global)
vagrant-persistent-storage (0.0.49, global)
vagrant-reload (0.0.1, global)
vagrant-vbguest (0.30.0, global)
```

## 🔖Todo
* Add timestamp to terminal prompt

* Favorites bar - måske med dconf load:?

  [dconf/gsettings læsning](https://askubuntu.com/questions/984205/how-to-save-gnome-settings-in-a-file)

## 🚧Manual workarounds
### Virtualbox guest additions
Ansible currently has a bug when installing VirtualBox guest additions. Instead, run the following from the host,

```
vagrant vbguest --do install
```
You might need to reboot for VM for it to take effect.

### 📂Shared folders
Leave the ` config.vm.synced_folder` outcommented on the very first `vagrant up`.
*Reason:* Vagrant executes the Vagrantfile in a haphazard order, which can cause issue with shared folders & (not yet) created users.

* If you mount a shared folder from host into your home dir in the VM, you risk that the `/home/<YOURUSER>/<SHARE>/` is created before the user itself, which caused all kinds of misbehavior - such as having `sh` be the default shell. And it doesn't throw an exception, so it can be tough to catch. *Hypothesis*: The requisite files for a new user aren't created, if the user's home dir already exists.
* If you instead mount to `/<NOT your user home dir>/` you'll still get an error when trying to set your user as owner of that dir. But at least it'll fail loudly so you know what's wrong.

### 🗺️Other workarounds
*Midnight Commander*
`~/.config/mc` skabes først, når MC bliver startet. Så Ansible kan ikke redigere ini'en på forhånd.

*Graphical issues*
Try `sudo gedit` and you'll see if you're affected. Garbles especially window titles & dialog prompts.
Wayland seems to be at fault on my system. Log out, and op for Ubuntu on Xorg instead: ([h/t](https://askubuntu.com/a/1403670/1001194))

[Graphical issues]:images/graphics-issues.png
[xorg or Wayland]:images/graphics_xorg-vs-wayland.png

## 🛠️Developing / Customizing

I propose the following tips for your workflow, if you wish to make your own changes.

### 🫵Personalizing
There are two ways to provide your personal user details,
**1: In the Vagrantfile**, by editing the `config.user.defaults` section
```
  config.user.defaults = {
    "user" => "user",
    "pwd" => "password",
    "fullname" => "Player the First",
    "email" => "user@example.com",
    "sshkey" => "c:/Users/user/.ssh/id",
    "vars" => {}
  }
```
2: By adding a .`.vagrantuser`. 

```
user: player1
pwd: password
fullname: Leroy Jenkins
email: iddqd@idkfa.cpm
sshkey: c:/Users/mla/.ssh/id
vars: {}
```

If both exist, `.vagrantuser`  takes precedence over the `config.user.defaults` section


### 🔁Create a snapshot right after installing Linux

1. `vagrant destroy` : Clean slate
2. `vagrant up`  # but with only playbook for installing ubuntu desktop, which is
    *the* huge time sink of building
3. `vagrant snapshot save default desktop` 
   (syntax: `vagrant snapshot save [vm-name] NAME`)

### Run Ansible playbooks

... either with `vagrant provision` from your host, which provisions on an already-running VM.

... or locally inside the VM with,
```
ansible-playbook -Ki localhost, <playbook.yaml> --connection=local
````
If your host system is Linux, you can also run ansible with the VM as target machine. This isn't possible with Windows, since it doesn't support Ansible.

## 💭*Idle thoughts*

*Strøtanker*, as we call them in Danish.

> In VM lingo we use the term,
> - *Host <---> Guest (VM)*
>
> With Ansible, the concepts are,
> - *Controller <---> Host (Target)*
>
> So if you say "Host" in a combined Vagrant+Ansible context, what do you mean? 🤔😜
> *#[JingleJangle](https://en.wikipedia.org/wiki/Jingle-jangle_fallacies)*