#!/usr/bin/env bash
source ./config.sh
HOSTNAME=$(hostname -s)
mkdir -p $BACKUPDIR/backup
mkdir -p $BACKUPDIR/archive
cp /var/opt/opscode/nginx/ca/*crt /etc/chef/trusted_certs/
mkdir -p $BACKUPDIR/certs $BACKUPDIR/backup/etc_opscode $BACKUPDIR/backup/certs
cp /var/opt/opscode/nginx/ca/* $BACKUPDIR/backup/certs
echo "These certs copied from /var/opt/opscode/nginx/ca/" > $BACKUPDIR/backup/certs/README.txt
cp /etc/opscode/* $BACKUPDIR/backup/etc_opscode
knife ec backup --purge $BACKUPDIR/backup
cd $BACKUPDIR
tar -zcf $BACKUPDIR/knife-ec-backup-$DATE.tar.gz backup
BACKUPFILE=`ls $BACKUPDIR/knife-ec-backup-$DATE*|tail -n 1`
BACKUPFILENAME=`basename $BACKUPFILE`
azcopy --quiet --source $BACKUPFILE --destination https://${STORACCT}.blob.core.windows.net/${CONTAINER}/${HOSTNAME}/${BACKUPFILENAME} --dest-key=${KEY}
azcopy --quiet --source $BACKUPFILE --destination https://${STORACCT}.blob.core.windows.net/${CONTAINER}/${HOSTNAME}/knife-ec-backup-latest.tar.gz --dest-key=${KEY}
mv $BACKUPDIR/*tar.gz $BACKUPDIR/archive
