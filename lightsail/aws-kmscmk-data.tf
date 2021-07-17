resource "aws_kms_key" "nc-kmscmk-s3-data" {
  description              = "S3 Key"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = "true"
  tags = {
    Name = "nc-kmscmk-s3-data"
  }
  policy = <<EOF
{
  "Id": "nc-kmskeypolicy-s3",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.nc-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access through S3",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.nc-data-user.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.nc-aws-account.account_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "nc-kmscmk-s3-data-alias" {
  name          = "alias/${random_string.nc-random.result}-nc-ksmcmk-s3-data"
  target_key_id = aws_kms_key.nc-kmscmk-s3.key_id
}
