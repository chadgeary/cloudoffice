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
- July 2021 - Please note, the duckdns domain feature was added (after videos were created). [duckdns.org](https://duckdns.org) is a free service to provide a domain name (that we sign with a [letsencrypt.org](https://letsencrypt.org) certificate with automatically). Though not required, duckdns is suggested for all new deployments. The certificate integrates better with Nextcloud and OnlyOffice apps and web browsers.
- October 2021 - Azure's security_group and security_group_rule resources conflict and overwrite eachother. The security_group_rule(s) have been put in security_group as inline.

# Github workflow set-up

We need a service principal that has permissions to deploy resources to Azure.
Create one with:

```
az account set --subscription "cloudoffice"

az ad sp create-for-rbac \
    --name sp-cloudoffice-github-actions \
    --sdk-auth \
    --role "Owner" \
    --scopes /subscriptions/$(az account show --query id -o tsv)
```

The response is the login details for the service principal. Github actions
needs these details in order to run Terraform. Add a secret
`AZURE_CREDENTIALS_SP_GITHUBCITERRAFORM` which contains the json response from
the command above.

Then, add another secret `TERRAFORM_STORAGE_ACCOUNT_NAME` that defines the
name of the storage account in which the Terraform state is kept.

Finally, fill in your [variables](azure/vars.tfvars).
