# Reference
Nextcloud + OnlyOffice deployed automatically via Terraform+Ansible in Oracle (OCI) cloud with object storage.

# Requirements
- An Oracle cloud account.
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

# Install terraform git and cli
brew install terraform git oci-cli

# Verify the three are installed
which terraform git gcloud oci-cli

# Skip down to 'git clone' below
```

Windows users install WSL (Windows Subsystem Linux)
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

# Download the Ubuntu 2204 package from Microsoft
curl.exe -L -o ubuntu-2204.AppxBundle https://aka.ms/wslubuntu2204
 
# Rename the package, unzip it, and cd (change directory)
Rename-Item ubuntu-2204.AppxBundle ubuntu-2204.zip
Expand-Archive ubuntu-2204.zip ubuntu-2204
cd ubuntu-2204

# Repeat the above three steps for the x64 file, update 0.10.0 if needed
Rename-Item ubuntu-2204.0.10.0_x64.zip ubuntu-2204_x64.zip
Expand-Archive ubuntu-2204_x64.zip ubuntu-2204_x64
cd ubuntu-2204_x64
 
# Execute the ubuntu installer
.\ubuntu2204.exe

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

Install the Oracle CLI and authenticate. An [OCI account](https://signup.oraclecloud.com/) is required to continue.
```
#############################
##         Oracle          ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Download the oracle CLI installer
curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh -o oci_install.sh

# Run the installer (enter linux password if prompted)
bash oci_install.sh --accept-all-defaults

# Refresh environment
source ~/.bashrc

# Copy user OCID from Oracle Web Console
# Navigate to Identity -> Users

# Copy tenancy OCID from Oracle Web Console
# Navigate to profile (top right) -> Tenancy: <some name>

# Setup oci CLI with user and tenancy OCID and a default region
oci setup config

# Earlier versions of oci cli did not require entering a passphrase for the private key (including in videos)
# Instead of generating a separate key, answer this question with your SSH private key's path
# Enter the location of your API Signing private key file: ~/.ssh/id_rsa

# Copy contents of your SSH's public key in PEM format to clipboard
openssl rsa -in ~/.ssh/id_rsa -pubout

# Add key via Oracle Web console
# Navigate to Identity -> Users -> <your user> -> API Keys (Bottom left, under Resource) -> Add Public Key -> Paste Public Keys

# Note command's output of config file location for vars file
ls ~/.oci/config

# Note command's output of OCI root compartment ID for vars file
oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]"
```

Customize the deployment - See variables section below
```
# Change to the project's oci directory in powershell
cd ~/cloudoffice/oci/

# Open File Explorer in a separate window
# Navigate to oci project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudoffice\oci

# Edit the oci.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's oci directory
cd ~/cloudoffice/oci/

# Initialize terraform and the apply the terraform state
terraform init
terraform apply -var-file="oci.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER oci.tfvars && chmod 600 oci.tfvars

# Note the outputs from terraform after the apply completes
# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the cloudoffice log file
tail -F /var/log/cloudoffice.log
```

# Variables
Edit the vars file (oci.tfvars) to customize the deployment, especially:

```
# admin_password
# password to access the webui, user is ncadmin

# db_password
# password used by nextcloud to read/write to databases

# oo_password
# password used by nextcloud to read/write to onlyoffice

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, instance SSH access.
# Deploying from home and only want to access it while at home? Set to your public IP address with a /32 suffix.
# Want worldwide access? Set to 0.0.0.0/0

# oci_config_profile
# The location of the oci config file (created by `oci setup config`)

# oci_root_compartment
# The OCID of the tenancy id (a.k.a. root compartment)

# OCI's managed Ubuntu 18.04 Minimal image, might need to be changed in the future as images are updated periodically
# See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-1804/
# Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
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
cd ~/cloudoffice/oci/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" oci.tfvars

# Alternatively, open access to world:
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"0.0.0.0/0\"#" oci.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="oci.tfvars"
```

- How do I update cloudoffice, database, and web proxy docker containers?
```
# Ensure terraform is up-to-date
sudo apt update && sudo apt-get install --only-upgrade terraform

# Be in the oci subdirectory
cd ~/cloudoffice/oci/

# Move vars file to be untracked by git, if not already done.
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv oci.tfvars pvars.tfvars; fi

# Pull updates
git pull

# Re-run terraform apply with your pvars file, see the update instructions in terraform's output
terraform init
terraform apply -var-file="pvars.tfvars"
```

- Using Firefox and OnlyOffice not loading when attempting to edit/view documents?
  - Visit https://your-cloudoffice-server-ip:your-oo-port (default 8443) and accept the certificate.
