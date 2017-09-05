# Description
This repository contains a template and other files necessary to build a Vagrant box for libvirt provider via [Packer](https://www.packer.io). At the moment, only libvirt provider is supported. This set of resources was created with the goal of setting up a disposable virtual environment for testing various technologies and tools, that's why the resulting image contains almost no additional packages - so that one could provision it with [Vagrant](https://www.vagrantup.com) for a more specific purpose. This template was written with isolated corporated environment in mind, hence proxy settings.

# Dependencies
The template uses **virt-sysprep** for cleaning the resulting image of any machine-specific configuration, making it suitable for cloning. It can be installed as following:
* `sudo apt-get install libguestfs-tools` on Debian 9 and it's derivatives.
* `sudo yum install libguestfs-tools-c` on CentOS 7 and it's derivatives.

# Caveats

virt-sysprep is likely to have problems accessing kernel images on Ubuntu based distributions due to [rigid permissions](https://bugs.launchpad.net/fuel/+bug/1467579), so if that's the case for you, it can be worked around as the following:
1. `chmod +x /boot/vmlinuz*`
2. To prevent this issue from bothering you again, create file `/etc/kernel/postinst.d/statoverride` with the following contents:
```
#!/bin/sh

version="$1"
[ -z "${version}" ] && exit 0
dpkg-statoverride --add root root 0644 /boot/vmlinuz-${version} --update
```
3. `chmod +x /etc/kernel/postinst.d/statoverride`

# Usage
Run `packer build template.json` to build a vagrant box. The template exposes several environment variables with preset defaults you can see by running `packer inspect template.json`. Variable's names are self-explanatory. 

To spin up the environment from this box via Vagrant, only 3 steps are required:
1. Create a Vagrantfile. You may use [this](https://github.com/AlekseyUsov/vagrant/blob/master/vagrantfile) as a template.
2. Add the box by running `vagrant box add`.
3. Bring up VM(s) by running `vagrant up`.

You're all set!

# Security Notes
The box is provisioned with a pre-created public key, contained in `files/authorized_keys`. You can (and should) replace it with your own and make sure you specify the corresponding private key in your Vagrantfile by setting **config.ssh.private_key_path**.


# Kickstart
You might want to change installation and base repository's urls, as well as timezone, in `kickstart/centos7-ks.cfg` based on your location.

# Compatibility
Tested with all combinations of the following versions of Packer, Vagrant, and Linux flavors:
Packer:
* 1.0.4

Vagrant:
* 1.9.7
* 1.9.8

Linux:
* Debian GNU/Linux 9
* Fedora 26
* Linux Mint 18.2.
