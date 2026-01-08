terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7"
    }
  }

  provider_meta "aws" {
    user_agent = [
      "github.com/terraform-aws-modules/terraform-aws-secrets-manager"
    ]
  }
}
