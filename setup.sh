#!/bin/bash -e

export PATH=/opt/opscode/embedded/bin:$PATH

sysctl -wq kernel.shmmax=17179869184
sysctl -wq net.ipv6.conf.lo.disable_ipv6=0

if ! stat -t /var/tmp/chef-server*.deb >/dev/null 2>&1
then
  wget -O chef-server.deb --no-check-certificate --content-disposition "http://www.opscode.com/chef/download-server?p=ubuntu&pv=14.04&m=x86_64&v=12&prerelease=false&nightlies=false"
fi

dpkg -i /var/tmp/*.deb
rm -f /var/tmp/*.deb

/opt/opscode/embedded/bin/runsvdir-start &

if [ -f "/root/chef_configured" ]
  then
    echo -e "\nChef Server already configured!\n"
    chef-server-ctl status
  else
    echo -e "\nNew install of Chef-Server!"
    /usr/local/bin/configure_chef.sh
fi

chef-server-ctl tail
