# docker-chef-backup-restore
A Dockerfile and scripts to backup and restore a chef server using knife ec backup. Backups use Azure blob storage but are just bash so can be tuned/altered to use anything.

This is something I spent some time getting together for my day job, so hopefully this will help others wanting to do a chef migration. Lots of information is out there, but not quite all the pieces were put together. This brings them closer.

# Getting started
You'll want to edit the following files to get this working:
* admin.pem - This needs to be a valid chef admin user's .pem file.
* knife.rb - Needs to be a valid knife.rb. Notably, it needs to point to the right user and chef server.
* scripts/config.sh - A number of variables need to be edited here.

## Using [knife ec backup](https://github.com/chef/knife-ec-backup)
This is a [knife](https://docs.chef.io/knife.html) module which connects to the chef server via its API. 

### Creating an knife ec backup Container

Using Docker for backups reduces the need to think about dependancies for `knife ec backup` which can be a bit finicky.

You'll also want a valid `/root/.chef/knife.rb` and user .pem file in the same directory for your backups. Best to use [chef-server-ctl](https://docs.chef.io/ctl_chef_server.html) to create a user. The creation of the knife.rb and pem file is outside the scope of this document.

There is a `build.sh` file which will create the container for you if you don't want to think about the docker commands to do so.

### Running the container
The `run.sh` script is sufficient to run the container. Once in the container, there's a /root/backup.sh file which you can use to run your backups. You can configure this to launch the container and the script via cron.

# The Restore

We can use the same container to restore the chef server.

## Chef Server Installation
You'll need to provision a server and install chef-server on it as documented [here](https://docs.chef.io/install_server.html).
1. Download the package from https://downloads.chef.io/chef-server/.
2. Run `sudo dpkg -i /tmp/chef-server-core-<version>.deb`
3. Run `sudo chef-server-ctl reconfigure`

At this point you'll have a server ready for a restore.

## Running the Restore

**If you plan on reusing the fqdn and certificates from your old server**
In the `/etc/opscode/chef-server.rb` file you'll want to ensure you have the following specified (with values filled in as appropriate):
```ruby
api_fqdn 'mychefserver.contoso.com'
nginx['ssl_certificate'] = '/var/opt/opscode/nginx/ca/mychefserver.contoso.com.crt'
nginx['ssl_certificate_key'] = '/var/opt/opscode/nginx/ca/mychefserver.contoso.com.key'
```
From here you can run the container on the server:
```bash
docker run --rm -it --network="host" -v /data:/data -v /etc/chef:/etc/chef -v/etc/opscode/:/etc/opscode -v/var/opt/opscode/nginx/ca:/var/opt/opscode/nginx/ca docker-ec-backup /bin/bash
```

The restore process will copy the server config files with the `restore.sh` command, and then require a `chef-server-ctl reconfigure`. After which `restore2.sh` can be run to restore all the data to the new server.

After this, test the new server by pointing some test nodes to it, and performing a few chef runs. You can point to a new server with the same fqdn by making an entry in the `/etc/hosts` file to override DNS.

# References
[Best Practices for Migrating your Chef Server](https://blog.chef.io/2018/04/06/best-practices-for-migrating-your-chef-server/)  
[Migrating your Chef Server with knife-ec-backup and knife-tidy](https://blog.chef.io/2017/10/16/migrating-chef-server-knife-ec-backup-knife-tidy/)  
[Backup and Restore a Chef server (uses chef-server-ctl)](https://docs.chef.io/server_backup_restore.html)  
[knife-ec-backup github](https://github.com/chef/knife-ec-backup)  