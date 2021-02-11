# passwords as encrypted ssm parameters
resource "aws_ssm_parameter" "nc-ssm-param-admin-pass" {
  name                    = "${var.name_prefix}-admin-password-${random_string.nc-random.result}"
  type                    = "SecureString"
  key_id                  = aws_kms_key.nc-kmscmk-ssm.key_id
  value                   = var.admin_password
}

resource "aws_ssm_parameter" "nc-ssm-param-db-pass" {
  name                    = "${var.name_prefix}-db-password-${random_string.nc-random.result}"
  type                    = "SecureString"
  key_id                  = aws_kms_key.nc-kmscmk-ssm.key_id
  value                   = var.db_password
}

resource "aws_ssm_parameter" "nc-ssm-param-oo-pass" {
  name                    = "${var.name_prefix}-oo-password-${random_string.nc-random.result}"
  type                    = "SecureString"
  key_id                  = aws_kms_key.nc-kmscmk-ssm.key_id
  value                   = var.oo_password
}

resource "aws_ssm_parameter" "nc-ssm-param-s3-access" {
  name                    = "${var.name_prefix}-s3-access-${random_string.nc-random.result}"
  type                    = "SecureString"
  key_id                  = aws_kms_key.nc-kmscmk-ssm.key_id
  value                   = aws_iam_access_key.nc-data-user-key.id
}

resource "aws_ssm_parameter" "nc-ssm-param-s3-secret" {
  name                    = "${var.name_prefix}-s3-secret-${random_string.nc-random.result}"
  type                    = "SecureString"
  key_id                  = aws_kms_key.nc-kmscmk-ssm.key_id
  value                   = aws_iam_access_key.nc-data-user-key.secret
}

# document to install deps and run playbook
resource "aws_ssm_document" "nc-ssm-doc" {
  name                    = "${var.name_prefix}-ssm-doc-${random_string.nc-random.result}"
  document_type           = "Command"
  content                 = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Ansible Playbooks via SSM for Ubuntu - installs Ansible properly.",
    "parameters": {
    "SourceType": {
      "description": "(Optional) Specify the source type.",
      "type": "String",
      "allowedValues": [
      "GitHub",
      "S3"
      ]
    },
    "SourceInfo": {
      "description": "Specify 'path'. Important: If you specify S3, then the IAM instance profile on your managed instances must be configured with read access to Amazon S3.",
      "type": "StringMap",
      "displayType": "textarea",
      "default": {}
    },
    "PlaybookFile": {
      "type": "String",
      "description": "(Optional) The Playbook file to run (including relative path). If the main Playbook file is located in the ./automation directory, then specify automation/playbook.yml.",
      "default": "hello-world-playbook.yml",
      "allowedPattern": "[(a-z_A-Z0-9\\-)/]+(.yml|.yaml)$"
    },
    "ExtraVariables": {
      "type": "String",
      "description": "(Optional) Additional variables to pass to Ansible at runtime. Enter key/value pairs separated by a space. For example: color=red flavor=cherry",
      "default": "SSM=True",
      "displayType": "textarea",
      "allowedPattern": "^$|^\\w+\\=[^\\s|:();&]+(\\s\\w+\\=[^\\s|:();&]+)*$"
    },
    "Verbose": {
      "type": "String",
      "description": "(Optional) Set the verbosity level for logging Playbook executions. Specify -v for low verbosity, -vv or vvv for medium verbosity, and -vvvv for debug level.",
      "allowedValues": [
      "-v",
      "-vv",
      "-vvv",
      "-vvvv"
      ],
      "default": "-v"
    }
    },
    "mainSteps": [
    {
      "action": "aws:downloadContent",
      "name": "downloadContent",
      "inputs": {
      "SourceType": "{{ SourceType }}",
      "SourceInfo": "{{ SourceInfo }}"
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "runShellScript",
      "inputs": {
      "runCommand": [
        "#!/bin/bash",
        "# Ensure ansible is installed",
        "sudo apt-get update",
        "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git",
        "sudo pip3 install ansible",
        "echo \"Running Ansible in `pwd`\"",
        "#this section locates files and unzips them",
        "for zip in $(find -iname '*.zip'); do",
        "  unzip -o $zip",
        "done",
        "PlaybookFile=\"{{PlaybookFile}}\"",
        "if [ ! -f  \"$${PlaybookFile}\" ] ; then",
        "   echo \"The specified Playbook file doesn't exist in the downloaded bundle. Please review the relative path and file name.\" >&2",
        "   exit 2",
        "fi",
        "/usr/local/bin/ansible-playbook -i \"localhost,\" -c local -e \"{{ExtraVariables}}\" \"{{Verbose}}\" \"$${PlaybookFile}\""
      ]
      }
    }
    ]
  }
DOC
}

# ansible playbook association
resource "aws_ssm_association" "nc-ssm-assoc" {
  association_name        = "${var.name_prefix}-ssm-assoc-${random_string.nc-random.result}"
  name                    = aws_ssm_document.nc-ssm-doc.name
  targets {
    key                   = "tag:Name"
    values                = ["${var.name_prefix}-instance-${random_string.nc-random.result}"]
  }
  output_location {
    s3_bucket_name          = aws_s3_bucket.nc-bucket.id
    s3_key_prefix           = "ssm"
  }
  parameters              = {
    ExtraVariables          = "SSM=True aws_region=${var.aws_region} name_prefix=${var.name_prefix} name_suffix=${random_string.nc-random.result} s3_bucket=${aws_s3_bucket.nc-bucket.id} kms_key_id=${aws_kms_key.nc-kmscmk-s3.key_id} docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_webproxy=${var.docker_webproxy} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_onlyoffice=${var.docker_onlyoffice} instance_public_ip=${aws_eip.nc-eip.public_ip} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory}"
    PlaybookFile            = "cloudoffice_aws.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.nc-bucket.id}/playbook/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
  depends_on              = [aws_iam_role_policy_attachment.nc-iam-attach-ssm, aws_iam_role_policy_attachment.nc-iam-attach-s3,aws_s3_bucket_object.nc-files]
}
