# Description
This repository contains a template and other files necessary to build a Vagrant box for libvirt provider via [Packer](https://www.packer.io). At the moment, only libvirt provider is supported. This set of resources was created with the goal of setting up a disposable virtual environment for testing various technologies and tools, that's why the resulting image contains almost no additional packages - so that one could provision it with [Vagrant](https://www.vagrantup.com) for a more specific purpose.

# Dependencies
The template uses **virt-sysprep** for cleaning the resulting image of any machine-specific configuration, making it suitable for cloning. It can be installed as following:
* `sudo apt-get install libguestfs-tools` on Debian 9 and it's derivatives.
* `sudo yum install libguestfs-tools-c` on CentOS 7 and it's derivatives.

# Using the box
To spin up the environment from this box via Vagrant, only 3 steps are required:
1. Create a Vagrantfile.
2. Add the box by running `vagrant box add`.
3. Bring up VM(s) by running `vagrant up`.

# Security Notes
The box is provisioned with a pre-created public key, contained in `files/authorized_keys`. You can (and should) replace it with your own and make sure you specify the corresponding private key in your Vagrantfile by setting **config.ssh.private_key_path**.

You're all set!

# Kickstart
You might want to change installation and base repository's urls, as well as timezone, in `kickstart/centos7-ks.cfg` based on your location.

# Compatibility
Tested with Packer v1.0.4 and Vagrant v1.9.7 on Debian GNU/Linux 9.
