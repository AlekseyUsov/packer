#!/bin/bash

USER_HOME=/home/vagrant
SSH_DIR=${USER_HOME}/.ssh
SSH_AUTH_KEYS=/tmp/authorized_keys
PROXY_HOST=$1
PROXY_PORT=$2
PROXY=${PROXY_HOST}:${PROXY_PORT}

# Install EPEL and additional useful packages
yum -y install epel-release
yum -y install htop

# Setting up .ssh directory for vagrant user
if [ ! -d ${SSH_DIR} ]; then
  mkdir -pm 0700 ${SSH_DIR}
fi

if [ -f ${SSH_AUTH_KEYS} ]; then
  mv ${SSH_AUTH_KEYS} ${SSH_DIR}
  chown -R vagrant:vagrant ${SSH_DIR} && chmod +x ${SSH_DIR}
fi

# Adding vagrant user to the sudoers file
echo "vagrant	ALL=(root) NOPASSWD:ALL" >> /etc/sudoers
echo "UseDNS no" >> /etc/ssh/sshd_config

# Setting up proxy, if needed
if [ ! -z "${PROXY_HOST}" ]; then
  echo -e proxy="http://${PROXY}\n" >> /etc/yum.conf
  echo -e "\nexport http_proxy=http://${PROXY}" >> /etc/profile
  echo -e "export https_proxy=https://${PROXY}\n" >> /etc/profile
fi

# Setting Message of the Day to the time of the build
echo -e "\nBuilt via packer (https://www.packer.io) at `date`\n" > /etc/motd
