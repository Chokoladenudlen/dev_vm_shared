#!/bin/bash
"""
dtp - Development Testing of Playbooks

Many Ansible playbooks depend on extra vars to be passed in. During normal
operation (building VM from scratch), this happens with the Vagrantfile, but
for development & testing the playbooks, we must pass them in manually - or 
with this script ;)

Tip: Run this script with subshell like this:
 (cd /kode/ubuntu_vm/src/ansible/; ./dtp.sh <playbook.yaml>)

"""

ansible-playbook -Ki localhost, $1 \
--connection=local \
--extra-vars "user=$USER sshkey=mla_skytem_id_ed25519"