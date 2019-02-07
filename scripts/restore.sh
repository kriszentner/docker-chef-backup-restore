#!/usr/bin/env bash
source ./config.sh
mkdir -p $BACKUPDIR/restore
azcopy --quiet --destination ${RESTOREDIR}/${RESTOREFILE} --source https://${STORACCT}.blob.core.windows.net/${CONTAINER}/${RESTOREHOSTNAME}/${RESTOREFILE} --source-key=${KEY}
cd $RESTOREDIR
tar -zxvf ${RESTOREFILE}
rm $RESTOREFILE
knife tidy backup clean --backup-path $RESTOREDIR/backup
cp $RESTOREDIR/backup/certs/*pem /var/opt/opscode/nginx/ca/
cp $RESTOREDIR/backup/certs/*crt /var/opt/opscode/nginx/ca/
cp $RESTOREDIR/backup/certs/*key /var/opt/opscode/nginx/ca/
cp $RESTOREDIR/backup/etc_opscode/chef-server.rb /etc/opscode/chef-server.rb
echo "Run: chef-server-ctl reconfigure on the root OS.
Then come back to the container and run restore2.sh"
