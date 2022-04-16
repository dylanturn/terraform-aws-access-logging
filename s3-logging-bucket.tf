
resource "aws_s3_bucket" "log_bucket" {
  bucket        = local.instance_name
  force_destroy = var.force_destroy

  tags = merge({
    storage_class  = "STANDARD_IA",
    retention_days = var.access_log_retention_days
  }, local.resource_tags)

}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.bucket
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_object_lock_configuration" "example" {
  count = var.enable_object_lock ? 1 : 0

  bucket = aws_s3_bucket.log_bucket.bucket

  object_lock_enabled = "Enabled"
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = var.access_log_retention_days
    }
  }
}

# Default bucket encryption on the target bucket can only be used if AES256 (SSE-S3) is selected. SSE-KMS encryption is not supported.
# https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html#server-access-logging-overview
resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket_lifecycle" {
  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    id = "access_logs"

    transition {
      days          = var.access_log_transition_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = (var.access_log_retention_days + 1)
    }

    status = "Enabled"
  }
}