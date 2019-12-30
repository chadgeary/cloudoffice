# Reference
Ansible playbook installs standalone Nextcloud with LetsEncrypt TLS Certificate

# Requirements
- centos 7
- epel and centos-release-scl repositories ( installed )
- valid public dns resolution (for certificate)

# Deployment
```
# locally
ansible-playbook nextcloud.yml --extra-vars "target=localhost nc_release='17.0.1' nc_friendly='mynextcloud.mydomain.com' nc_datadir='/opt/nextcloud' certbot_contact_email='someone@mydomain.com'"
```

# Variables
```
# target - the host(s) to install nextcloud, e.g.:
somehost.chadg.net

# nc_release - the version of nextcloud to fetch/install, e.g.:
17.0.1

# nc_friendly - the dns name of the httpd server, must be resolvable externally, e.g:
nextcloud1.chadg.net

# nc_datadir - the directory nextcloud will store user/service data, e.g.:
/opt/nextcloud

# certbot_contact_email - an email address to register with eff / certbot, e.g.:
someadmin@chadg.net
```

# Admin authentication
admin is created at installation, password is randomly generated @ /opt/ncadmin.txt

# LDAP authentication
```
# before enabling the Nextcloud LDAP addon
sudo yum install rh-php72-php-ldap
sudo setsebool -P httpd_can_connect_ldap on
sudo systemctl restart httpd

# freeipa user query example
(&(&(|(objectclass=posixAccount))(|(memberof=cn=ipausers,cn=groups,cn=accounts,dc=chadg,dc=net)))(uid=%uid))
```
