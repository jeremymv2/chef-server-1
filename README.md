# chef-server-docker

Not officially supported by Chef!!!!
This is for proof of concept only!

chef-server-docker will run a standalone Chef Server in an Ubuntu Trusty 14.04 LTS container.

This is a fork of: [c-buisson/chef-server](https://github.com/c-buisson/chef-server)

## Quickstart

1. If needed modify `variables.sh`
2. Optionally download the version of a .deb package for Chef Server desired into this directory (otherwise latest stable will be downloaded into the container)
3. execute `./build`
2. execute `./run`

## State
State is preserved via `/var/opt` volume mounted on the host.
Use `docker stop <container>` to gracefully quiesce PostgreSQL and other services.

## Protocol / Port
Chef is running over HTTPS/443 by default.
You can however change that to another port by adding `-e SSL_PORT=new_port` to the `docker run` command below and update the expose port `-p` accordingly.

## SSL certificate
When Chef Server gets configured it creates an SSL certificate based on the container's FQDN (i.e "103d6875c1c5" which is the "CONTAINER ID"). This default behiavior has been changed to always produce an SSL certificate file named "chef-server.crt".  
You can change the certificate name by adding  `-e CONTAINER_NAME=new_name` to the `docker run` command. Remember to reflect that change in config.rb!

## DNS
The container needs to be **DNS resolvable!**  
Be sure **'chef-server'** or **$CONTAINER_NAME** is pointing to the container's IP!  
This needs to be done to match the SSL certificate name with the `chef_server_url ` from knife's `config.rb` file.
