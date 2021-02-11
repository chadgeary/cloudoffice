resource "aws_iam_user" "nc-data-user" {
  name                    = "nc-data-user-${random_string.nc-random.result}"
}

resource "aws_iam_access_key" "nc-data-user-key" {
  user                    = aws_iam_user.nc-data-user.name
}

resource "aws_iam_policy" "nc-data-user-policy-s3" {
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
      "Sid": "DeleteObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject"
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
      "Resource": ["${aws_kms_key.nc-kmscmk-s3-data.arn}"]
    }
  ]
}
EOF
}

# data user role
resource "aws_iam_role" "nc-data-user-s3-role" {
  name                    = "nc-data-user-${random_string.nc-random.result}-role"
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

# data user role attach policy
resource "aws_iam_role_policy_attachment" "nc-data-user-s3-role-policy-attach" {
  role                    = aws_iam_role.nc-data-user-s3-role.name
  policy_arn              = aws_iam_policy.nc-data-user-policy-s3.arn
}
