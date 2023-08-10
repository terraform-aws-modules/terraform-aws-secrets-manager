provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

locals {
  region = "eu-west-1"
  name   = "secrets-manager-ex-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-secrets-manager"
  }
}

################################################################################
# Secrets Manager
################################################################################

module "secrets_manager" {
  source = "../.."

  # Secret
  name_prefix             = local.name
  description             = "Example Secrets Manager secret"
  recovery_window_in_days = 0
  replica = {
    # Can set region as key
    us-east-1 = {}
    another = {
      # Or as attribute
      region = "us-west-2"
    }
  }

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  # Version
  create_random_password           = true
  random_password_length           = 64
  random_password_override_special = "!@#$%^&*()_+"

  tags = local.tags
}

module "secrets_manager_rotate" {
  source = "../.."

  # Secret
  name_prefix             = local.name
  description             = "Rotated example Secrets Manager secret"
  recovery_window_in_days = 0

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    lambda = {
      sid = "LambdaReadWrite"
      principals = [{
        type        = "AWS"
        identifiers = [module.lambda.lambda_role_arn]
      }]
      actions = [
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
        "secretsmanager:UpdateSecretVersionStage",
      ]
      resources = ["*"]
    }
    account = {
      sid = "AccountDescribe"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }]
      actions   = ["secretsmanager:DescribeSecret"]
      resources = ["*"]
    }
  }

  # Version
  ignore_secret_changes = true
  secret_string = jsonencode({
    engine   = "mariadb",
    host     = "mydb.cluster-123456789012.us-east-1.rds.amazonaws.com",
    username = "Bill",
    password = "ThisIsMySuperSecretString12356!"
    dbname   = "mydb",
    port     = 3306
  })

  # Rotation
  enable_rotation     = true
  rotation_lambda_arn = module.lambda.lambda_function_arn
  rotation_rules = {
    # This should be more sensible in production
    schedule_expression = "rate(6 hours)"
  }

  tags = local.tags
}

module "secrets_manager_disabled" {
  source = "../.."

  create = false
}

################################################################################
# Supporting Resources
################################################################################

# https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets-required-permissions-function.html
data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage",
    ]
    resources = [module.secrets_manager.secret_arn]
  }

  statement {
    actions   = ["secretsmanager:GetRandomPassword"]
    resources = ["*"]
  }

  statement {
    actions   = ["secretsmanager:GetRandomPassword"]
    resources = ["*"]
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  function_name = local.name
  description   = "Example Secrets Manager secret rotation lambda function"

  handler     = "function.lambda_handler"
  runtime     = "python3.10"
  timeout     = 60
  memory_size = 512
  source_path = "${path.module}/function.py"

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.this.json

  publish = true
  allowed_triggers = {
    secrets = {
      principal = "secretsmanager.amazonaws.com"
    }
  }

  cloudwatch_logs_retention_in_days = 7

  tags = local.tags
}
