# s3 bucket
resource "aws_s3_bucket" "nc-bucket-data" {
  bucket        = "${var.name_prefix}-${random_string.nc-random.result}-data"
  force_destroy = true
}

# acl
resource "aws_s3_bucket_acl" "nc-bucket-data" {
  bucket = aws_s3_bucket.nc-bucket-data.id
  acl    = "private"
}

# versioning
resource "aws_s3_bucket_versioning" "nc-bucket-data" {
  bucket = aws_s3_bucket.nc-bucket-data.id
  versioning_configuration {
    status = "Suspended"
  }
}

# encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "nc-bucket-data" {
  bucket = aws_s3_bucket.nc-bucket-data.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.nc-kmscmk-s3-data.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# access policy
resource "aws_s3_bucket_policy" "nc-bucket-data-policy" {
  bucket = aws_s3_bucket.nc-bucket-data.id
  policy = data.aws_iam_policy_document.nc-bucket-data-policy.json
}

# s3 block all public access to bucket
resource "aws_s3_bucket_public_access_block" "nc-bucket-data-pubaccessblock" {
  bucket                  = aws_s3_bucket.nc-bucket-data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# policy data
data "aws_iam_policy_document" "nc-bucket-data-policy" {
  statement {
    sid       = "KMSManager"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data", "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data/*"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_iam_user.nc-kmsmanager.arn}"]
    }
  }

  statement {
    sid       = "IAMUser"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:PutObjectAcl", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data", "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}-data/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.nc-data-user.arn}"]
    }
  }
}
