#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

rolesdir=$(dirname $0)/..

#[ ! -d $rolesdir/redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/redhat-epel
#[ ! -d $rolesdir/geerlingguy.nginx ] && git clone https://github.com/geerlingguy/ansible-role-nginx.git $rolesdir/geerlingguy.nginx
[ ! -d $rolesdir/juju4.w3af ] && git clone https://github.com/juju4/ansible-w3af $rolesdir/juju4.w3af
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.harden-nginx ] && ln -s ansible-harden-nginx $rolesdir/juju4.harden-nginx
[ ! -e $rolesdir/juju4.harden-nginx ] && cp -R $rolesdir/ansible-harden-nginx $rolesdir/juju4.harden-nginx

## don't stop build on this script return code
true

