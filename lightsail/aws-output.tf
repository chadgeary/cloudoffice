output "cloudoffice-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############

## SSH ##
ssh ubuntu@${aws_lightsail_static_ip.nc-staticip.ip_address}

## WebUI ##
${var.enable_duckdns == 1 && var.web_port == "443" ? "https://${var.duckdns_domain}/nc" : ""}${var.enable_duckdns == 1 && var.web_port != "443" ? "https://${var.duckdns_domain}:${var.web_port}/nc" : ""}${var.enable_duckdns == 0 && var.web_port == "443" ? "https://${aws_lightsail_static_ip.nc-staticip.ip_address}" : ""}${var.enable_duckdns == 0 && var.web_port != "443" ? "https://${aws_lightsail_static_ip.nc-staticip.ip_address}:${var.web_port}/" : ""}

## ################### ##
## Update Instructions ##
## ################### ##
# Move vars file to be untracked by git (one time command)
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv aws.tfvars pvars.tfvars; fi

# Pull updates
git pull

# If updating containers
# remove the old containers - this brings down the service until ansible is re-applied.
ssh ubuntu@${aws_lightsail_static_ip.nc-staticip.ip_address}
sudo docker rm -f cloudblock_application cloudblock_database cloudblock_webproxy cloudblock_onlyoffice
exit

# Re-run terraform apply with your pvars file
terraform apply -var-file="pvars.tfvars"

# Re-apply the AWS SSM association from your local machine
~/.local/bin/aws ssm start-associations-once --region ${var.aws_region} --association-ids ${aws_ssm_association.nc-ssm-assoc.association_id}
OUTPUT
}
