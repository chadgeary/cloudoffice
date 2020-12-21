#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
pip3 install --upgrade ansible oci
ansible-galaxy collection install oracle.oci
mkdir -p /opt/git/nextcloud
git clone ${project_url} /opt/git/nextcloud
cd /opt/git/nextcloud
git pull
cd playbooks/
ansible-playbook nextcloud_oci.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_nextcloud=${docker_nextcloud} docker_db=${docker_db} docker_webproxy=${docker_webproxy} admin_password_cipher=${admin_password_cipher} db_password_cipher=${db_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} oci_root_compartment=${oci_root_compartment}' >> /var/log/nextcloud.log
