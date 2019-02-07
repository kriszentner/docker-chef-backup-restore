#!/usr/bin/env bash
source ./config.sh
mkdir -p /root/.chef/trusted_certs
cp ${RESTOREDIR}/backup/certs/*crt /root/.chef/trusted_certs/
ex -s /etc/hosts << EOH
%s/\(127\.0\.0\.1\ localhost\)/\1 ${CHEFHOSTFQDN}/
w!
q
EOH
echo "Doing a dry run"
sleep 2
knife ec restore --dry-run ${RESTOREDIR}/backup
echo "Dry run complete. Perform the restore yourself using:
knife ec restore ${RESTOREDIR}/backup"
