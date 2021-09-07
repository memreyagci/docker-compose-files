Ansible configuration for my development & production servers.

### Requirements
- Tested in **Ubuntu 20.4 LTS**
- **[ansible-stow](https://github.com/caian-org/ansible-stow) module**, for deploying dotfiles
- **[ansible.posix](https://github.com/ansible-collections/ansible.posix) module**, for mounting block-storage devices, to use for Docker volume backups
- A user named ansible that belongs to sudo group

### Usage
**For the servers**, I use the following startup script for installation, which creates a user called ansible that belongs to sudo group, and adds my ssh key:
```
#!/bin/sh

useradd -mG sudo -s /bin/bash -p $(echo $mypasswd | openssl passwd -1 -stdin) ansible

su -c "mkdir /home/ansible/.ssh" ansible

su -c "echo "$host_ssh" > /home/ansible/.ssh/authorized_keys" ansible
```
---
For the host machine, first, you need to clone the repository:
```
$ git clone --recurse-submodules https://github.com/memreyagci/server-configs
```
>Note: *"--recurse-submodules" is to clone turtl server into roles/containers/files, since it is a submodule of my server-configs repository.*

\
Thereafter, cd into server-configs and run the following command:
```
$ ansible-playbook $playbook --ask-become-pass --ask-vault-pass
```

> There are two playbooks: dev_servers.yml & prod_servers.yml

### Roles
* **dev_server.yml & prod_server.yml** include the roles to run, as their names indicate they are run in different servers defined in /etc/ansible/hosts
* **group_vars**:
   * **all.yml** includes username and password of the account which will be used as the main user of the server (for ssh connections, container managemenet, etc.)
   * **dev_servers.yml & prod_servers.yml** consists of domains we want to use for the servers, also database passwords and admin tokens of some of the containers.
* **roles**:
   * **containers**: As the name suggests this role deploys the following Docker containers.
      * **Traefik**: A reverse proxy that deals with routing connections to other containers.
      * **Baikal**: CardDAV & CalDAV server
      * **Ghost**: A blogging platform
      * **Turtl**: Note-taking server
      * **Vaultwarden**: Password management server
   * **cronjobs**: It adds a script I wrote called backup-docker-volumes to cron.
   * **dotfiles**: Deploys my dotfiles using GNU Stow
   * **mount**: Adds the block-storage device to the fstab and mounts it.
   * **packages**: Installs necessary packages for the server. Some of them are: rsync, Docker, neovim, stow, python3-pip..
   * **users**: Creates a user of sudo and docker groups for main usage.
