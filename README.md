# Overview
Nextcloud built in the cloud automatically using Terraform with Ansible. Now with optional duckdns.org/letsencrypt support!

Available for several major cloud providers, including: AWS (EC2 or Lightsail), Azure, Digital Ocean, GCP (Google), OCI (Oracle), Scaleway (scw) + standalone Raspberry Pi/Ubuntu Server deployment options.

![Diagram](cloudofficediagram.png)

# Instructions
Several deployment options are available, see the README of each subdirectory for platform-specific guides. For standalone deployments, see the playbooks/ directory.

# Videos
Cloud deployments:
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
- July 2021 - Please note, duckdns domains have been added since the videos were created. [duckdns.org](duckdns.org) is a free service to provide a domain name (that we can sign an HTTPS certificate with automatically). Though not required, duckdns is suggested for all new deployments. The signed certificate integrates better with Nextcloud and OnlyOffice apps and web browsers.
