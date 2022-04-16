
resource "aws_s3_bucket" "log_bucket" {
  bucket        = local.instance_name
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy
  tags = merge({
    storage_class  = "STANDARD_IA",
    retention_days = var.access_log_retention_days
  }, local.resource_tags)

  dynamic "object_lock_configuration" {
    for_each = var.enable_object_lock ? ["Enabled"] : []
    content {
      object_lock_enabled = object_lock_configuration.value
      rule {
        default_retention {
          mode = "COMPLIANCE"
          days = var.access_log_retention_days
        }
      }
    }
  }

  # Default bucket encryption on the target bucket can only be used if AES256 (SSE-S3) is selected. SSE-KMS encryption is not supported.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html#server-access-logging-overview
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "access_logs"
    enabled = true
    transition {
      days          = var.access_log_transition_days
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = (var.access_log_retention_days + 1)
    }
  }
}