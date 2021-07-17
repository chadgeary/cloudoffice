# s3 bucket
resource "aws_s3_bucket" "nc-bucket" {
  bucket = "${var.name_prefix}-${random_string.nc-random.result}"
  acl    = "private"
  versioning {
    enabled = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.nc-kmscmk-s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle_rule {
    id      = "${var.name_prefix}-backup-lifecycle"
    enabled = true
    prefix  = "nextcloud/"
    noncurrent_version_expiration {
      days = 7
    }
  }
  force_destroy = true
  policy        = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "KMS Manager",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${data.aws_iam_user.nc-kmsmanager.arn}"]
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}",
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/*"
      ]
    },
    {
      "Sid": "Instance List",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.nc-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}"]
    },
    {
      "Sid": "Instance Get",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.nc-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/*"]
    },
    {
      "Sid": "Instance Put",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.nc-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/ssm/*",
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/nextcloud/*"
      ]
    }
  ]
}
POLICY
}

# s3 block all public access to bucket
resource "aws_s3_bucket_public_access_block" "nc-bucket-pubaccessblock" {
  bucket                  = aws_s3_bucket.nc-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# s3 objects (playbook)
resource "aws_s3_bucket_object" "nc-files" {
  for_each       = fileset("../playbooks/", "*")
  bucket         = aws_s3_bucket.nc-bucket.id
  key            = "playbook/${each.value}"
  content_base64 = base64encode(file("${path.module}/../playbooks/${each.value}"))
  kms_key_id     = aws_kms_key.nc-kmscmk-s3.arn
}
