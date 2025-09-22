locals {
  secret_string            = var.create_random_password ? random_password.this[0].result : var.secret_string
  secret_string_wo         = null # Write-only not supported in OpenTofu yet
  secret_string_wo_version = null # Write-only not supported in OpenTofu yet
}

resource "random_password" "this" {
  count = var.create && var.create_random_password ? 1 : 0

  length           = var.random_password_length
  special          = true
  override_special = var.random_password_override_special
}
