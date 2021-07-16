# Reference
Nextcloud deployed automatically via Terraform+Ansible in Azure (Microsoft) cloud.

# Requirements
- An Azure cloud account.
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step
Mac Users install (home)brew, then terraform, git, az cli.
```
#########
## Mac ##
#########
# Launch terminal

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew up-to-date
brew update

# Install terraform and git
brew install terraform git azure-cli

# Verify the three are installed
which terraform git az

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

Install the Azure CLI and authenticate. An [Azure account](https://azure.microsoft.com/en-us/free/) is required to continue.
```
#############################
##          Azure          ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Install the azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Authenticate (for WSL users, login to the browser popup!)
az login
```

Customize the deployment - See variables section below
```
# Change to the project's azure directory in powershell
cd ~/cloudoffice/azure/

# Open File Explorer in a separate window
# Navigate to oci project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudoffice\azure

# Edit the az.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's azure directory
cd ~/cloudoffice/azure/

# Initialize terraform and the apply the terraform state
terraform init
terraform apply -var-file="az.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER az.tfvars && chmod 600 az.tfvars

# Note the outputs from terraform after the apply completes
# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the log file
tail -F /var/log/cloudoffice.log
```

# Variables
Edit the vars file (az.tfvars) to customize the deployment, especially:

```
# admin_password
# Nextcloud administrator WebUI password, user is ncadmin

# db_password
# Password used by nextcloud to read/write to database

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, instance SSH access. (default).
# Deploying from home and only want to access it while at home? Set to your public IP address with a /32 suffix.
# Want worldwide access? Set to 0.0.0.0/0
```

# Post-Deployment
- See terraform output for WebUI access.
- Note cloud storage directory at WebUI login -> Files. If adding additional users, ensure awareness of shared access (or otherwise edit).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.

```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudoffice/azure/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" az.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="az.tfvars"
```

- How do I update nextcloud, database, minio, and web proxy docker containers?
```
# Ensure terraform is up-to-date
sudo apt update && sudo apt-get install --only-upgrade terraform

# Be in the azure subdirectory
cd ~/cloudoffice/azure/

# Move vars file to be untracked by git, if not already done.
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv az.tfvars pvars.tfvars; fi

# Pull updates
git pull

# Re-run terraform apply with your pvars file, see the update instructions in terraform's output
terraform init
terraform apply -var-file="pvars.tfvars"
```

- Using Firefox and OnlyOffice not loading when attempting to edit/view documents?
  - Visit https://your-cloudoffice-server-ip:your-oo-port (default 8443) and accept the certificate.
