#!/usr/bin/env bash

set -x

if [[ -z $SSL_PORT ]]; then
  echo "nginx['ssl_port']=443" >> /etc/opscode/chef-server.rb
else
  echo "nginx['ssl_port']=$SSL_PORT" >> /etc/opscode/chef-server.rb
fi

if [[ -z $API_FQDN ]]; then
  echo "api_fqdn \"chef-server\"" >> /etc/opscode/chef-server.rb
else
  echo "api_fqdn \"$API_FQDN\"" >> /etc/opscode/chef-server.rb
fi

echo -e "\nRunning: 'chef-server-ctl reconfigure'. This step will take a few minutes..."
chef-server-ctl reconfigure

echo -e "\nRunning: 'chef-server-ctl install chef-manage'"...
chef-server-ctl install chef-manage
/opt/chef-manage/embedded/bin/runsvdir-start &

echo -e "\nRunning: 'chef-server-ctl reconfigure'"...
chef-server-ctl reconfigure

echo -e "\nRunning: 'chef-manage-ctl reconfigure'"...
chef-manage-ctl reconfigure --accept-license

chef-server-ctl start
chef-manage-ctl start

touch /var/opt/opscode/chefserver_docker_bootstrapped

echo -e "\n\nDone!\n"
