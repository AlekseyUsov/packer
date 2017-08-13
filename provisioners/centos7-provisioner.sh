#!/bin/bash

USER_HOME=/home/vagrant
SSH_DIR=$USER_HOME/.ssh

# Installing EPEL and additional packages
yum -y install epel-release
yum -y install htop

# Setting up .ssh directory for vagrant user
if [ ! -d $SSH_DIR ]; then
  mkdir -pm 0700 $SSH_DIR
fi

mv /tmp/authorized_keys $SSH_DIR
chown -R vagrant:vagrant $SSH_DIR && chmod +x $SSH_DIR

# Adding vagrant user to the sudoers file
echo "vagrant	ALL=(root) NOPASSWD:ALL" >> /etc/sudoers
echo "UseDNS no" >> /etc/ssh/sshd_config

# Setting Message of the Day to the time of the build
echo -e "\nBuilt via packer (https://www.packer.io) at `date`\n" > /etc/motd
