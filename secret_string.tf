locals {
  secret_string            = var.secret_string
  secret_string_wo         = var.create_random_password ? ephemeral.random_password.this[0].result : var.secret_string_wo
  secret_string_wo_version = var.create_random_password ? coalesce(var.secret_string_wo_version, 0) : var.secret_string_wo_version
}

variable "secret_string_wo" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if `secret_binary` or `secret_string` is not set"
  type        = string
  default     = null
  ephemeral   = true
}

variable "secret_string_wo_version" {
  description = "Used together with `secret_string_wo` to trigger an update. Increment this value when an update to `secret_string_wo` is required"
  type        = string
  default     = null
}

ephemeral "random_password" "this" {
  count = var.create && var.create_random_password ? 1 : 0

  length           = var.random_password_length
  special          = true
  override_special = var.random_password_override_special
}
