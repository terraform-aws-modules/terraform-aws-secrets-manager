
################################################################################
# Secret
################################################################################

resource "aws_secretsmanager_secret" "this" {
  count = var.create ? 1 : 0

  region = var.region

  description                    = var.description
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  kms_key_id                     = var.kms_key_id
  name                           = var.name
  name_prefix                    = var.name_prefix
  recovery_window_in_days        = var.recovery_window_in_days

  dynamic "replica" {
    for_each = var.replica != null ? var.replica : {}

    content {
      kms_key_id = replica.value.kms_key_id
      region     = coalesce(replica.value.region, replica.key)
    }
  }

  tags = var.tags
}

################################################################################
# Policy
################################################################################

data "aws_iam_policy_document" "this" {
  count = var.create && var.create_policy ? 1 : 0

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.policy_statements != null ? var.policy_statements : {}

    content {
      sid           = statement.value.sid
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.create && var.create_policy ? 1 : 0

  region = var.region

  block_public_policy = var.block_public_policy
  policy              = data.aws_iam_policy_document.this[0].json
  secret_arn          = aws_secretsmanager_secret.this[0].arn
}

################################################################################
# Version
################################################################################

resource "aws_secretsmanager_secret_version" "this" {
  count = var.create && !(var.enable_rotation || var.ignore_secret_changes) ? 1 : 0

  region = var.region

  secret_id                = aws_secretsmanager_secret.this[0].id
  secret_binary            = var.secret_binary
  secret_string            = var.secret_string
  secret_string_wo         = var.create_random_password ? ephemeral.random_password.this[0].result : var.secret_string_wo
  secret_string_wo_version = var.create_random_password ? coalesce(var.secret_string_wo_version, 0) : var.secret_string_wo_version
  version_stages           = var.version_stages
}

resource "aws_secretsmanager_secret_version" "ignore_changes" {
  count = var.create && (var.enable_rotation || var.ignore_secret_changes) ? 1 : 0

  region = var.region

  secret_id                = aws_secretsmanager_secret.this[0].id
  secret_binary            = var.secret_binary
  secret_string            = var.secret_string
  secret_string_wo         = var.create_random_password ? ephemeral.random_password.this[0].result : var.secret_string_wo
  secret_string_wo_version = var.create_random_password ? coalesce(var.secret_string_wo_version, 0) : var.secret_string_wo_version
  version_stages           = var.version_stages

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
      version_stages,
    ]
  }
}

ephemeral "random_password" "this" {
  count = var.create && var.create_random_password ? 1 : 0

  length           = var.random_password_length
  special          = true
  override_special = var.random_password_override_special
}

################################################################################
# Rotation
################################################################################

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.create && var.enable_rotation ? 1 : 0

  region = var.region

  rotate_immediately  = var.rotate_immediately
  rotation_lambda_arn = var.rotation_lambda_arn

  dynamic "rotation_rules" {
    for_each = var.rotation_rules != null ? [var.rotation_rules] : []

    content {
      automatically_after_days = rotation_rules.value.automatically_after_days
      duration                 = rotation_rules.value.duration
      schedule_expression      = rotation_rules.value.schedule_expression
    }
  }

  secret_id = aws_secretsmanager_secret.this[0].id
}
