resource "random_string" "random_instance_id" {
  length  = 6
  special = false
}

locals {
  instance_id   = lower(random_string.random_instance_id.result)
  instance_name = "${var.organization_name}-${var.environment}-${var.support_department_code}-access-logs.${local.instance_id}.${lookup(local.region_abbrs, var.region, null)}"
  resource_tags = merge({
    instance_name    = local.instance_name
    service          = "access-logging",
    terraform-module = "terraform-aws-access-logging"
  }, var.tags)

  ### TODO: Come up with a nicer way to store these kinds of constants
  regional_elb_log_delivery_account_map = {
    us-east-1      = "127311923021", # US East (N. Virginia)
    us-east-2      = "033677994240", # US East (Ohio)
    us-west-1      = "027434742980", # US West (N. California)
    us-west-2      = "797873946194", # US West (Oregon)
    ca-central-1   = "985666609251", # Canada (Central)
    eu-central-1   = "054676820928", # Europe (Frankfurt)
    eu-west-1      = "156460612806", # Europe (Ireland)
    eu-west-2      = "652711504416", # Europe (London)
    eu-west-3      = "009996457667", # Europe (Paris)
    ap-northeast-1 = "582318560864", # Asia Pacific (Tokyo)
    ap-northeast-2 = "600734575887", # Asia Pacific (Seoul)
    ap-northeast-3 = "383597477331", # Asia Pacific (Osaka-Local)
    ap-southeast-1 = "114774131450", # Asia Pacific (Singapore)
    ap-southeast-2 = "783225319266", # Asia Pacific (Sydney)
    ap-south-1     = "718504428378", # Asia Pacific (Mumbai)
    sa-east-1      = "507241528517", # South America (São Paulo)
  }

  ### TODO: Come up with a nicer way to store these kinds of constants
  region_abbrs = {
    us-east-1      = "use1",  # US East (N. Virginia)
    us-east-2      = "use2",  # US East (Ohio)
    us-west-1      = "usw1",  # US West (N. California)
    us-west-2      = "usw2",  # US West (Oregon)
    af-south-1     = "afs1",  # Africa (Cape Town)
    ap-east-1      = "ape1",  # Asia Pacific (Hong Kong)
    ap-south-1     = "aps1",  # Asia Pacific (Mumbai)
    ap-northeast-3 = "apne3", # Asia Pacific (Osaka-Local)
    ap-northeast-2 = "apne2", # Asia Pacific (Seoul)
    ap-northeast-1 = "apne1", # Asia Pacific (Tokyo)
    ap-southeast-1 = "apse1", # Asia Pacific (Singapore)
    ap-southeast-2 = "apse2", # Asia Pacific (Sydney)
    ca-central-1   = "cac1",  # Canada (Central)
    cn-north-1     = "cnn1",  # China (Beijing)
    cn-northwest-1 = "cnnw1", # China (Ningxia)
    eu-central-1   = "euc1",  # Europe (Frankfurt)
    eu-west-1      = "euw1",  # Europe (Ireland)
    eu-west-2      = "euw2",  # Europe (London)
    eu-south-1     = "eus1",  # Europe (Milan)
    eu-west-3      = "euw3",  # Europe (Paris)
    eu-north-1     = "eun1",  # Europe (Stockholm)
    me-south-1     = "mes1",  # Middle East (Bahrain)
    sa-east-1      = "sae1",  # South America (São Paulo)
    us-gov-east-1  = "usge1", # AWS GovCloud (US-East)
    us-gov-west-1  = "usgw1"  # AWS GovCloud (US)
  }
}