################################################################################
# Ephemeral Secret Generation
################################################################################

ephemeral "random_password" "this" {
  for_each = var.secrets
  length   = 32
}

################################################################################
# Secrets Manager
################################################################################

resource "aws_secretsmanager_secret" "this" {
  for_each = var.secrets
  name     = each.key
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each         = var.secrets
  secret_id        = aws_secretsmanager_secret.this[each.key].id
  secret_string_wo = ephemeral.random_password.this[each.key].result

  # secret_string_wo_version must be incremented any time secret_string_wo
  # changes, since Terraform can't diff a value it never persists to state.
  # Hardcoded to 1 here because this example only demonstrates initial
  # creation; a real rotation workflow would bump this (e.g. via a
  # timestamp, a rotation-trigger variable, or a CI pipeline input) to
  # force Terraform to regenerate and rewrite the secret value.
  secret_string_wo_version = 1
}
