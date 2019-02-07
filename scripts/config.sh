#!/usr/bin/env bash
export BACKUPDIR="/data/knife-ec-backup"
export RESTOREDIR="/data/knife-ec-restore"
export KEY="yourkeyhere"
export STORACCT="mybackupacct"
export CONTAINER="docker-ec-backup"
# Directory used in Azure Storage
export RESTOREHOSTNAME="mychefserver"
# Used to populate container /etc/hosts so we restore to the local server, and not the server we backed up from.
export CHEFHOSTFQDN="mychefserver.contoso.com"
export RESTOREFILE="knife-ec-backup-latest.tar.gz"
export DATE=$(date +%Y-%m-%d)
