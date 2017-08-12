#!/bin/bash

USER_HOME=/home/vagrant
SSH_DIR=$USER_HOME/.ssh

# Installing EPEL and additional packages
yum -y install epel-release
yum -y install htop
yum -y clean all

# Setting up .ssh directory
if [ ! -d $SSH_DIR ]; then
  mkdir -pm 0700 $SSH_DIR
fi

mv /tmp/authorized_keys $SSH_DIR
chown -R vagrant:vagrant $SSH_DIR && chmod +x $SSH_DIR

# Adding vagrant user to the sudoers file
echo "vagrant	ALL=(root) NOPASSWD:ALL" >> /etc/sudoers
echo "UseDNS no" >> /etc/ssh/sshd_config

# Generalizing the VM for being used as a template
sed -i '/^UUID\|^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-*
rm -f /etc/ssh/ssh_host_*
rm -rf /tmp/*
rm -f /etc/udev/rules.d/70-*
rm -f /var/lib/dhclient/dhclient-eth*.leases

# Setting Message of the Day to the time of the build
echo -e "\nBuilt via packer (https://www.packer.io) at `date`\n" > /etc/motd
