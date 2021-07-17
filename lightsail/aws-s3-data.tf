# s3 bucket
resource "aws_s3_bucket" "nc-bucket-data" {
  bucket = "${var.name_prefix}-${random_string.nc-random.result}-data"
  acl    = "private"
  versioning {
    enabled = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.nc-kmscmk-s3-data.arn
        sse_algorithm     = "aws:kms"
      }
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
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data",
        "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data/*"
      ]
    },
    {
      "Sid": "Iam user bucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_user.nc-data-user.arn}"]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data"]
    },
    {
      "Sid": "Iam user objects",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_user.nc-data-user.arn}"]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data/*"]
    }
  ]
}
POLICY
}

# s3 block all public access to bucket
resource "aws_s3_bucket_public_access_block" "nc-bucket-pubaccessblock-data" {
  bucket                  = aws_s3_bucket.nc-bucket-data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
