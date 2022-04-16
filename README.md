# terraform-aws-access-logging
Terraform module for deploying an appropriately configured and secured AWS S3 bucket for access log collection

## Getting started:
1. `terraform apply -target module.access-logging` 

**Note:**
This access log bucket cannot be destroyed (hence the random ID in the name), before destroying a stack that contains this bucket, one will need to remove it from state with a `terraform state rm module.{access-log-bucket-name}`

## Access-Log Bucket
* Creates an encrypted s3 access logging bucket
* Creates a rule that moves log objects to cheaper storage after 7 days
* Makes objects in the bucket read-only for 13months (403 days) when they're created
* Deletes access log objects after 13 months and a day
* Includes a policy to block and ignore all public access points