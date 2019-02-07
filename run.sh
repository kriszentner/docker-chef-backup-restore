#!/usr/bin/env bash
docker run --rm -it --network="host" -v /data:/data -v /etc/chef:/etc/chef -v/etc/opscode/:/etc/opscode -v/var/opt/opscode/nginx/ca:/var/opt/opscode/nginx/ca docker-ec-backup /bin/bash
