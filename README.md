[![Actions Status - Master](https://github.com/juju4/ansible-harden-nginx/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-harden-nginx/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-harden-nginx/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-harden-nginx/actions?query=branch%3Adevel)

# Nginx webserver hardening ansible role

Ansible role to harden nginx webserver.

This role offers multiple option to handle certificates (See hardenwebserver_cert variable):
* self-signed
* mkcert (recommended only for development)
* letsencrypt through ansible modules. It does not handle renewal and role must be run around renewal time for it to happen.
* letsencrypt through certbot. It does handle renewal.
* Smallstep step-ca

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0
 * 2.1
 * 2.2 (required for letsencrypt module/option)
 * 2.14

### Operating systems

Ubuntu 22.04, 20.04, 18.04 and Centos7

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

*Pay attention to following defaults variables*
This leverage systemd to reduce nginx privileges but it requires some files to get extra acl to work, typically ssl certificate and key or logs

```
hardenwebserver_nginx_systemd_hardening: true
hardenwebserver_systemd_files_acl:
#    - { p: "/etc/ssl/private", perm: rx }
#    - { p: "/etc/ssl/private/{{ ansible_fqdn }}.key", perm: r }
    - { p: "/var/log/nginx", perm: rwx }
#    - { p: /etc/letsencrypt/archive, perm: rx }
#    - { p: /etc/letsencrypt/live, perm: rx }
#    - { p: "/etc/letsencrypt/archive/{{ ansible_fqdn }}/privkey1.pem", perm: r }
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

* no CSP report log?
Maybe because of uBlock Origin browser extension: [Block CSP reports. Enabled by default in Firefox in 1.31.3rc1 to mitigate fingerprinting attempts described in LiCybora/NanoDefenderFirefox#196. Dec 2020](https://github.com/gorhill/uBlock/wiki/Dashboard:-Settings#block-csp-reports)

* when using step-ca and creating certificate, getting "client GET https://<SERVER>:8443/provisioners?limit=100 failed: Forbidden": check that you are not blocked at a proxy level, either with no_proxy env, either allowed at proxy level.

* ci default-multisites failing with "error allocating terminal: open /dev/tty: no such device or address": https://github.com/smallstep/cli/issues/674, https://github.com/smallstep/cli/issues/502 both opened

## Extras

* If you want to warn users who use old browsers, the following projects are among the options to add little warnings: (browser-update.org)[https://browser-update.org/], (outdatedbrowser.com)[http://outdatedbrowser.com/]

## License

BSD 2-clause
