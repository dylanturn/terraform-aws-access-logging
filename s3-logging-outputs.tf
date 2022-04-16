output "id" {
  description = "This buckets id."
  value       = aws_s3_bucket.log_bucket.id
}
output "arn" {
  description = "This buckets arn."
  value       = aws_s3_bucket.log_bucket.arn
}
output "name" {
  description = "This buckets name."
  value       = aws_s3_bucket.log_bucket.bucket
}

output "region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.log_bucket.region
}

output "bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.log_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name for this logging bucket."
  value       = aws_s3_bucket.log_bucket.bucket_regional_domain_name
}