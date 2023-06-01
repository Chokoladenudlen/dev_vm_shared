#!/bin/bash

# This is a workaround, a hack. To solve issues that I haven't yet found a 
# way to do via Vagrant or Ansible. In other words, these are things, I 
# don't know how to provision, and therefore must do manually from within th
# VM - by running this script.

# Disable lock screen
gsettings set org.gnome.desktop.lockdown disable-lock-screen true


# Locale, keyboard & taskbar customization

# Locallization & keyboard can be provisioned with Ansible galaxy roles
# gantsign.keyboard & oefenweb.locales. But there is something about the 
# timing: If I provision ubuntu desktop & then reboot, the roles don't work.

# dconf-settings.ini also defines taskbar location & icons
dconf load / < /vagrant/src/deploy_files/dconf-settings.ini
