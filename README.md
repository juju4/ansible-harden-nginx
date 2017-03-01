[![Build Status - Master](https://travis-ci.org/juju4/ansible-harden-nginx.svg?branch=master)](https://travis-ci.org/juju4/ansible-harden-nginx)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-harden-nginx.svg?branch=devel)](https://travis-ci.org/juju4/ansible-harden-nginx/branches)
# Nginx webserver hardening ansible role

Ansible role to harden nginx webserver.

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0
 * 2.1
 * 2.2 (required for letsencrypt module/option)

### Operating systems

Ubuntu 14.04, 16.04 and Centos7

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - juju4.harden-nginx
```

## Variables

See defaults/main.yml
```
#hardenwebserver_nginx_resolver: '$DNS-IP-1 $DNS-IP-2'
hardenwebserver_disable_http: false
hardenwebserver_https_noconfig: false
hardenwebserver_block_downloadagents: false
hardenwebserver_cachecontrol: false

## if defined, restrict webserver listen interface (only support one interface)
#hardenwebserver_bind: 192.168.1.1

hardenwebserver_certinfo: '/C=US/ST=CA/L=San Francisco/O=Ansible'
#hardenwebserver_cert: selfsigned
hardenwebserver_certduration: 1095
## Ansible v2.2 module. will use hostname fqdn
hardenwebserver_cert: letsencrypt
# path on orchestrator, if empty will be created
hardenwebserver_letsencrypt_user_key: ''
## staging or production url
hardenwebserver_letsencrypt_acme_dir: 'https://acme-staging.api.letsencrypt.org/directory'
#hardenwebserver_letsencrypt_acme_dir: 'https://acme-v01.api.letsencrypt.org/directory'
hardenwebserver_rootdir: /var/www/html
```


## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).
Default kitchen config (.kitchen.yml) is lxd-based, while (.kitchen.vagrant.yml) is vagrant/virtualbox based.

Once you ensured all necessary roles are present, You can test with:
```
$ gem install kitchen-ansible kitchen-lxd_cli kitchen-sync kitchen-vagrant
$ cd /path/to/roles/juju4.harden-nginx
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```
or
```
$ cd /path/to/roles/juju4.harden-nginx/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues


## License

BSD 2-clause

