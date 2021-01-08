# SSM Managed Policy
data "aws_iam_policy" "nc-instance-policy-ssm" {
  arn                     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Policy SSM Parameter
resource "aws_iam_policy" "nc-instance-policy-ssmparameter" {
  name                    = "nc-instance-policy-${random_string.nc-random.result}-ssmparameter"
  path                    = "/"
  description             = "Provides instance access to the ssm parameter(s)"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GetSSMParameter",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": ["${aws_ssm_parameter.nc-ssm-param-admin-pass.arn}","${aws_ssm_parameter.nc-ssm-param-db-pass.arn}","${aws_ssm_parameter.nc-ssm-param-oo-pass.arn}"]
    },
    {
      "Sid": "DecryptSSMwithCMK",
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": ["${aws_kms_key.nc-kmscmk-ssm.arn}"]
    }
  ]
}
EOF
}

# Instance Policy S3
resource "aws_iam_policy" "nc-instance-policy-s3" {
  name                    = "nc-instance-policy-${random_string.nc-random.result}-s3"
  path                    = "/"
  description             = "Provides instance access to s3 objects/bucket"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsinBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket.arn}"]
    },
    {
      "Sid": "GetObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket.arn}/playbooks/*"]
    },
    {
      "Sid": "PutObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket.arn}/ssm/*"]
    },
    {
      "Sid": "EncryptDecryptS3withCMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["${aws_kms_key.nc-kmscmk-s3.arn}"]
    }
  ]
}
EOF
}

# Instance Policy S3 data
resource "aws_iam_policy" "nc-instance-policy-s3-data" {
  name                    = "nc-instance-policy-${random_string.nc-random.result}-s3-data"
  path                    = "/"
  description             = "Provides instance access to data s3 objects/bucket"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsinBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket-data.arn}"]
    },
    {
      "Sid": "GetObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket-data.arn}/*"]
    },
    {
      "Sid": "PutObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.nc-bucket-data.arn}/*"]
    },
    {
      "Sid": "EncryptDecryptS3withCMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["${aws_kms_key.nc-kmscmk-s3.arn}"]
    }
  ]
}
EOF
}

# Instance Role
resource "aws_iam_role" "nc-instance-iam-role" {
  name                    = "nc-instance-profile-${random_string.nc-random.result}-role"
  path                    = "/"
  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
             "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
      }
  ]
}
EOF
}

# Instance Role Attachments
resource "aws_iam_role_policy_attachment" "nc-iam-attach-ssm" {
  role                    = aws_iam_role.nc-instance-iam-role.name
  policy_arn              = data.aws_iam_policy.nc-instance-policy-ssm.arn
}

resource "aws_iam_role_policy_attachment" "nc-iam-attach-ssmparameter" {
  role                    = aws_iam_role.nc-instance-iam-role.name
  policy_arn              = aws_iam_policy.nc-instance-policy-ssmparameter.arn
}

resource "aws_iam_role_policy_attachment" "nc-iam-attach-s3" {
  role                    = aws_iam_role.nc-instance-iam-role.name
  policy_arn              = aws_iam_policy.nc-instance-policy-s3.arn
}

resource "aws_iam_role_policy_attachment" "nc-iam-attach-s3-data" {
  role                    = aws_iam_role.nc-instance-iam-role.name
  policy_arn              = aws_iam_policy.nc-instance-policy-s3-data.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "nc-instance-profile" {
  name                    = "nc-instance-profile-${random_string.nc-random.result}"
  role                    = aws_iam_role.nc-instance-iam-role.name
}
