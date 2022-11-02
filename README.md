# Overview
Nextcloud built in the cloud automatically using Terraform with Ansible. Now with optional duckdns.org/letsencrypt support!

Available for several major cloud providers, including: AWS (EC2 or Lightsail), Azure, Digital Ocean, GCP (Google), OCI (Oracle), Scaleway (scw) + standalone Raspberry Pi/Ubuntu Server deployment options.

![Diagram](cloudofficediagram.png)

# Instructions
Several deployment options are available, see the README of each subdirectory for platform-specific guides. For standalone deployments, see the playbooks/ directory.

# Videos
Cloud deployments:
Choosing a cloud provider? [Watch this](https://youtu.be/HB7VwTffdIY) for a mostly un-biased comparison of free options/free trials.

- [Prerequisites](https://youtu.be/SJ0hrXPbMNo) - Watch this first if deploying in the cloud.
- [AWS](https://youtu.be/Y1kUaYYDMvc)
- [Azure](https://youtu.be/xS80EdVuJhU)
- [DigitalOcean](https://youtu.be/Npgenw8It6c)
- [Google Cloud](https://youtu.be/Sr3kA9GJrU0)
- [Oracle Cloud](https://youtu.be/5Qaj6E2_mIY)

Standalone:
- [Ubuntu](https://youtu.be/5uWyZl7ZpC4)

# Discussion
[Discord Room](https://discord.gg/TT8vrcnw6x)

# Changelog

### 2021-07
* duckdns domain feature was added (after videos were created). [duckdns.org](https://duckdns.org) is a free service to provide a domain name (that we sign with a [letsencrypt.org](https://letsencrypt.org) certificate with automatically).
* Though not required, duckdns is suggested for all new deployments. The trusted certificate integrates better with Nextcloud and OnlyOffice apps + web browsers.

### 2021-10
* Azure's security_group and security_group_rule resources now conflict and overwrite eachother. The security_group_rule(s) have been put in security_group as inline.

### 2022-10
* Added references to Ubuntu 22.04 (replacing Ubuntu 18.04) for:
  * WSL installation
  * Cloud virtual machine images
* Note about Oracle's private key generation for `oci config`
* Fixed [13](https://github.com/chadgeary/cloudoffice/issues/13) placeholder email address
