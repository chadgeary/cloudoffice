# Reference
Nextcloud + OnlyOffice deployed automatically via Terraform+Ansible in Scaleway (scw) cloud with object storage. Not familiar with Scaleway? They are a cloud provider headquartered in Europe.

# Requirements
- A Scaleway cloud account, billing enabled (at least test-level).
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

# Download cloud cli - see latest version and alternative architecture @ https://github.com/scaleway/scaleway-cli/releases
curl -o ~/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.3.0/scw-2.3.0-darwin-x86_64"
chmod +x ~/scw

# Add alias
echo "alias scw ~/scw" >> ~/.bash_profile && source ~/.bash_profile

# Verify the three are installed
which terraform git gcloud scw

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

Install the Scaleway CLI and authenticate/generate token+key. A [Scaleway Account](https://console.scaleway.com/register) is required to continue.
```
#############################
##         Scaleway        ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# WSL Install scaleway-cli via github prebuilt binary
sudo curl -o /usr/local/bin/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.3.0/scw-2.3.0-linux-x86_64"
sudo chmod +x /usr/local/bin/scw

# Generate an API key @ https://console.scaleway.com/project/credentials
# Save the access key and secret key, they're used in the next step and further down under Deploy section.

# Add key to scw when prompted
scw init
```

Customize the deployment - See variables section below
```
# Change to the project's scw directory in powershell
cd ~/cloudoffice/scw/

# Open File Explorer in a separate window
# Navigate to the scw project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudoffice\scw

# Edit the scw.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's scw directory
cd ~/cloudoffice/scw/

# Initialize terraform and the apply the terraform state
terraform init
terraform apply -var-file="scw.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER scw.tfvars && chmod 600 scw.tfvars

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
Edit the vars file (scw.tfvars) to customize the deployment, especially:

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

# scw_accesskey
# The scaleway access key, used by nextcloud to talk with scaleway's object storage (username)

# scw_secretkey
# The scaleway secret key, used by nextcloud to talk with scaleway's object storage (password)
```

# Post-Deployment and FAQs
- See terraform output for WebUI access.
- Note cloud storage directory at WebUI login -> Files -> cloud_storage. If adding additional users, ensure awareness of shared access (or otherwise edit).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.
  - Additionally, setting the mgmt_cidr to 0.0.0.0/0 enables world access to the web interface and ssh. Use a strong password!

```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudoffice/scw/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" scw.tfvars
# Alternatively, open access to world:
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"0.0.0.0/0\"#" scw.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="scw.tfvars"
```

- How do I update cloudoffice and the other docker containers?
  - The terraform output provides the steps to perform updates.
  - Keep this repository up-to-date too.

```
# Ensure terraform is up-to-date
sudo apt update && sudo apt-get install --only-upgrade terraform

# Be in the do subdirectory
cd ~/cloudoffice/scw/

# Move vars file to be untracked by git, if not already done.
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv scw.tfvars pvars.tfvars; fi

# Pull updates
git pull

# Re-run terraform apply with your pvars file, see the update instructions in terraform's output
terraform init
terraform apply -var-file="pvars.tfvars"
```

- Using Firefox and OnlyOffice not loading when attempting to edit/view documents?
  - Visit https://your-cloudoffice-server-ip:your-oo-port (default 8443) and accept the certificate.
