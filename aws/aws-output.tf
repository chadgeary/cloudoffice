output "cloudblock-output" {
  value = <<OUTPUT
  
  #############  
  ## OUTPUTS ##
  #############
  
  ## SSH ##
  ssh ubuntu@${aws_eip.nc-eip.public_ip}
  
  ## WebUI ##
  https://${aws_eip.nc-eip.public_ip}:${var.web_port}/
  
  ## Update / Ansible Rerun ##
  # Move vars file to be untracked by git (one time command)
  if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv aws.tfvars pvars.tfvars; fi

  # Pull updates
  git pull

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  ssh ubuntu@${aws_eip.nc-eip.public_ip}
  sudo docker rm -f nextcloud_application nextcloud_database nextcloud_webproxy
  exit
  
  # Re-run terraform apply with your pvars file
  terraform apply -var-file="pvars.tfvars"

  # Re-apply the AWS SSM association from your local machine
  ~/.local/bin/aws ssm start-associations-once --region ${var.aws_region} --association-ids ${aws_ssm_association.nc-ssm-assoc.association_id}
  OUTPUT
}
