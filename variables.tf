### Partner Environment Variables ###

variable "organization_name" {
  type        = string
  description = "The organization that owns the account this bucket is being created in."
}

variable "force_destroy" {
  type        = string
  description = "Should we force destroy"
  default     = false
}

variable "account_id" {
  type        = string
  description = "The name of this account"
}

variable "environment" {
  type        = string
  description = "The environment these module resources are being created in"
}

variable "region" {
  type        = string
  description = "The region these module resources are being created in"
}

variable "support_department" {
  type        = string
  description = "The name of this services support department"
}

variable "support_department_code" {
  type        = string
  description = "A three letter acronym for the support department"
}

variable "support_contact" {
  type        = string
  description = "The email address for this services support department"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to include with the resources created by this module"
  default     = {}
}

## Resource Specific Variables ###
variable "access_log_retention_days" {
  type        = number
  description = "The number of days to retain access logs for this bucket. Default is 403 days"
  default     = 403
}
variable "access_log_transition_days" {
  type        = number
  description = "The number of days to keep access logs on the standard tier before transitioning them off to the infrequent access tier"
  default     = 30
}
variable "enable_object_lock" {
  type        = bool
  description = "A configuration of S3 object locking (https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html)"
  default     = true
}
variable "lifecycle_rule" {
  type        = any
  description = "List of maps containing configuration of object lifecycle management"
  default     = []
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  default     = true
}