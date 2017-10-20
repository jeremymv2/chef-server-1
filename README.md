# chef-server

chef-server will run latest Chef Server 12 in an Ubuntu Trusty 14.04 LTS container.
Image Size: Approximately 1GB

This is a fork of: [c-buisson/chef-server](https://github.com/c-buisson/chef-server)

WORK IN PROGRESS!!! Not officially supported.

## Quickstart

1. `./build`
2. `./run`

## Environment
##### Protocol / Port
Chef is running over HTTPS/443 by default.
You can however change that to another port by adding `-e SSL_PORT=new_port` to the `docker run` command below and update the expose port `-p` accordingly.

##### SSL certificate
When Chef Server gets configured it creates an SSL certificate based on the container's FQDN (i.e "103d6875c1c5" which is the "CONTAINER ID"). This default behiavior has been changed to always produce an SSL certificate file named "chef-server.crt".  
You can change the certificate name by adding  `-e CONTAINER_NAME=new_name` to the `docker run` command. Remember to reflect that change in config.rb!

##### Logs
`/var/log/` is accessible via a volume directory. Feel free to optionally to use it with the `docker run` command above by adding: `-v ~/chef-logs:/var/log`

##### DNS
The container needs to be **DNS resolvable!**  
Be sure **'chef-server'** or **$CONTAINER_NAME** is pointing to the container's IP!  
This needs to be done to match the SSL certificate name with the `chef_server_url ` from knife's `config.rb` file.
