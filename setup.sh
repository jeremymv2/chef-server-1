#!/usr/bin/env bash

set -x

export PATH=/opt/opscode/embedded/bin:$PATH

# Shut down nicely when we're told to stop
# We could further customize this to do a reconfigure, etc based on signal.
trap cleanup SIGTERM
trap cleanup SIGKILL

cleanup() {
  echo 'Stopping services' | wall
  chef-server-ctl stop || true
  sleep 1
  exit 0
}

sysctl -wq kernel.shmmax=17179869184
sysctl -wq net.ipv6.conf.lo.disable_ipv6=0

if ! stat -t /var/tmp/chef-server*.deb >/dev/null 2>&1
then
  wget -O chef-server.deb --no-check-certificate --content-disposition "http://www.opscode.com/chef/download-server?p=ubuntu&pv=14.04&m=x86_64&v=12&prerelease=false&nightlies=false"
fi

dpkg -i /var/tmp/*.deb
rm -f /var/tmp/*.deb
/opt/opscode/embedded/bin/runsvdir-start &

if [ -f "/var/opt/opscode/chefserver_docker_bootstrapped" ]
  then
    echo -e "\nChef Server already setup!\n"
    /opt/opscode/embedded/bin/runsvdir-start &
    chef-server-ctl reconfigure
    chef-server-ctl start
    chef-server-ctl status
  else
    echo -e "\nNew install of Chef-Server!"
    /usr/local/bin/configure_chef.sh
fi

/usr/sbin/ntpd

# wait forever
while true
do
  chef-server-ctl tail & wait ${!}
done
