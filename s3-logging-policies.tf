resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.log_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "access_logs_policy" {
  bucket = aws_s3_bucket.log_bucket.bucket
  policy = data.aws_iam_policy_document.access_logs_policy.json
}

# Allows delivery.logs.amazonaws.com to put objects into this bucket, (provided the objects are owned by the bucket owner)
data "aws_iam_policy_document" "access_logs_policy" {

  # Allows delivery.logs.amazonaws.com to get this buckets ACL.
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}",
    ]
  }

  # Allows the AWS Log delivery service to upload VPC flow logs and S3 access logs.
  # S3 access logging documentation: https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html#how-logs-delivered
  # VPC flow log documentation: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control",
      ]
    }
  }

  # Allows the root user in the AWS account that delivers ELB logs or a particular region, (provided the objects are owned by the bucket owner).
  # See the "Bucket Permissions" section of https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(local.regional_elb_log_delivery_account_map, var.region, null)}:root"]
    }
    actions = [
      "s3:PutObject",

    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}/*",
    ]
  }
}