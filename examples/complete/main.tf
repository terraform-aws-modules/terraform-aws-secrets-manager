provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "secrets-manager-ex-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/clowdhaus/terraform-aws-secrets-manager"
  }
}

################################################################################
# secrets manager Module
################################################################################

module "secrets_manager" {
  source = "../.."

  create = false

  tags = local.tags
}

module "secrets_manager_disabled" {
  source = "../.."

  create = false
}
