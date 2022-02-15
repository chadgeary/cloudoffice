# s3 bucket
resource "aws_s3_bucket" "nc-bucket" {
  bucket        = "${var.name_prefix}-${random_string.nc-random.result}"
  force_destroy = true
}

# acl
resource "aws_s3_bucket_acl" "nc-bucket" {
  bucket = aws_s3_bucket.nc-bucket.id
  acl    = "private"
}

# versioning
resource "aws_s3_bucket_versioning" "nc-bucket" {
  bucket = aws_s3_bucket.nc-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "nc-bucket" {
  bucket = aws_s3_bucket.nc-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.nc-kmscmk-s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# access policy
resource "aws_s3_bucket_policy" "nc-bucket-policy" {
  bucket = aws_s3_bucket.nc-bucket.id
  policy = data.aws_iam_policy_document.nc-bucket-policy.json
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
resource "aws_s3_object" "nc-files" {
  for_each       = fileset("../playbooks/", "**")
  bucket         = aws_s3_bucket.nc-bucket.id
  key            = "playbook/${each.value}"
  content_base64 = base64encode(file("${path.module}/../playbooks/${each.value}"))
  kms_key_id     = aws_kms_key.nc-kmscmk-s3.arn
}

# policy data
data "aws_iam_policy_document" "nc-bucket-policy" {
  statement {
    sid       = "KMSManager"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}", "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_iam_user.nc-kmsmanager.arn}"]
    }
  }

  statement {
    sid       = "InstanceListGet"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetObject", "s3:GetObjectVersion"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}", "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.nc-instance-iam-role.arn}"]
    }
  }

  statement {
    sid       = "InstancePut"
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:PutObjectAcl"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/ssm/*", "arn:aws:s3:::${var.name_prefix}-${random_string.nc-random.result}/nextcloud/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.nc-instance-iam-role.arn}"]
    }
  }
}
