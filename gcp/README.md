# Reference
Nextcloud + OnlyOffice deployed automatically via Terraform+Ansible in Google (GCP) cloud with object storage.

# Requirements
- A Google cloud account
- Follow Step-by-Step (compatible with Windows and Ubuntu)
- *NEW* Optionally setup a duckdns.org domain, this is suggested for all new installations!

# Step-by-Step 
Mac Users install (home)brew, then terraform, git, cloud cli.
```
#########
## Mac ##
#########
# Launch terminal

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew up-to-date
brew update

# Install terraform git 
brew install terraform git 

# Download gcp cli (64-bit) - see latest versions and alternative architectures @ https://cloud.google.com/sdk/docs/quickstart#mac
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-341.0.0-darwin-x86_64.tar.gz

# Extract
tar -xvf google-cloud-sdk-341.0.0-darwin-x86_64.tar.gz

# Install
./google-cloud-sdk/install.sh

# Add cli alias
echo "alias gcloud ~/google-cloud-sdk/bin/gcloud" >> ~/.bash_profile && source ~/.bash_profile

# Verify the three are installed
which terraform git gcloud

# Skip down to 'git clone' below
```

Windows Users install WSL (Windows Subsystem Linux)
```
#############################
## Windows Subsystem Linux ##
#############################
# Launch an ELEVATED Powershell prompt (right click -> Run as Administrator)

# Enable Windows Subsystem Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Reboot your Windows PC
shutdown /r /t 5

# After reboot, launch a REGULAR Powershell prompt (left click).
# Do NOT proceed with an ELEVATED Powershell prompt.

# Download the Ubuntu 1804 package from Microsoft
curl.exe -L -o ubuntu-1804.appx https://aka.ms/wsl-ubuntu-1804
 
# Rename the package
Rename-Item ubuntu-1804.appx ubuntu-1804.zip
 
# Expand the zip
Expand-Archive ubuntu-1804.zip ubuntu-1804
 
# Change to the zip directory
cd ubuntu-1804
 
# Execute the ubuntu 1804 installer
.\ubuntu1804.exe
 
# Create a username and password when prompted
```

Install Terraform, Git, and create an SSH key pair
```
#############################
##  Terraform + Git + SSH  ##
#############################
# Add terraform's apt key (enter previously created password at prompt)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
 
# Add terraform's apt repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
 
# Install terraform and git
sudo apt-get update && sudo apt-get -y install terraform git
 
# Clone the project
git clone https://github.com/chadgeary/cloudoffice

# Create SSH key pair (RETURN for defaults)
ssh-keygen
```

Install the GCP CLI and authenticate. A [GCP account](https://console.cloud.google.com/) is required to continue.
```
#############################
##           GCP           ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Add the google cloud sdk repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Install prerequisite packages
sudo apt-get -y install apt-transport-https ca-certificates gnupg

# Add the google cloud package key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install the google cloud sdk package
sudo apt-get update && sudo apt-get -y install google-cloud-sdk

# Authenticate - copy link to browser, auth, and paste response. If prompted for a project, create new with name: default
gcloud init

# Enable application-default login
gcloud auth application-default login

# Note the billing ID for the vars file
gcloud beta billing accounts list | grep True

# Note the gcp user (account) for the vars file
gcloud auth list
```

Customize the deployment - See variables section below
```
# Change to the project's aws directory in powershell
cd ~/cloudoffice/gcp/

# Open File Explorer in a separate window
# Navigate to gcp project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudoffice\gcp

# Edit the gcp.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's gcp directory
cd ~/cloudoffice/gcp/

# Initialize terraform and apply the terraform state
terraform init
terraform apply -var-file="gcp.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER gcp.tfvars && chmod 600 gcp.tfvars

# Note the outputs from terraform after the apply completes
# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the cloudblock log file
tail -F /var/log/cloudoffice.log
```

# Variables
Edit the vars file (gcp.tfvars) to customize the deployment, especially:

```
# admin_password
# password to access the webui, user is ncadmin

# db_password
# password used by nextcloud application to read/write to databases

# oo_password
# password used by nextcloud application to read/write to onlyoffice

# ssh_key
# a public SSH key for SSH access to the instance via user `ubuntu`.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# IP range granted SSH and WebUI access to cloud instance.
# Deploying from home and only want to access it while at home? Set to your public IP address with a /32 suffix.
# Want worldwide access? Set to 0.0.0.0/0

# gcp_billing_account
# The billing ID for the google cloud account

# gcp_user
# The GCP user
```

# Post-Deployment and FAQs
- See terraform output for WebUI access.
- Note cloud storage directory at WebUI login -> Files. If adding additional users, ensure awareness of shared access (or otherwise edit).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.
```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudoffice/gcp/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" gcp.tfvars

# Alternatively, open access to world:
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"0.0.0.0/0\"#" gcp.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="gcp.tfvars"
```

- How do I update nextcloud and the other containers?
```
# Ensure terraform is up-to-date
sudo apt update && sudo apt-get install --only-upgrade terraform

# Be in the gcp subdirectory
cd ~/cloudoffice/gcp/

# Move vars file to be untracked by git, if not already done.
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv gcp.tfvars pvars.tfvars; fi

# Pull cloudoffice updates
git pull

# Re-run terraform apply with your pvars file, see the update instructions in terraform's output
terraform init
terraform apply -var-file="pvars.tfvars"
```

- Using Firefox and OnlyOffice not loading when attempting to edit/view documents?
  - Visit https://your-cloudoffice-server-ip:your-oo-port (default 8443) and accept the certificate.
