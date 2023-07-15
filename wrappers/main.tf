module "wrapper" {
  source = "../"

  for_each = var.items

  create                           = try(each.value.create, var.defaults.create, true)
  tags                             = try(each.value.tags, var.defaults.tags, {})
  description                      = try(each.value.description, var.defaults.description, null)
  force_overwrite_replica_secret   = try(each.value.force_overwrite_replica_secret, var.defaults.force_overwrite_replica_secret, null)
  kms_key_id                       = try(each.value.kms_key_id, var.defaults.kms_key_id, null)
  name                             = try(each.value.name, var.defaults.name, null)
  name_prefix                      = try(each.value.name_prefix, var.defaults.name_prefix, null)
  recovery_window_in_days          = try(each.value.recovery_window_in_days, var.defaults.recovery_window_in_days, null)
  replica                          = try(each.value.replica, var.defaults.replica, {})
  create_policy                    = try(each.value.create_policy, var.defaults.create_policy, false)
  source_policy_documents          = try(each.value.source_policy_documents, var.defaults.source_policy_documents, [])
  override_policy_documents        = try(each.value.override_policy_documents, var.defaults.override_policy_documents, [])
  policy_statements                = try(each.value.policy_statements, var.defaults.policy_statements, {})
  block_public_policy              = try(each.value.block_public_policy, var.defaults.block_public_policy, null)
  ignore_secret_changes            = try(each.value.ignore_secret_changes, var.defaults.ignore_secret_changes, false)
  secret_string                    = try(each.value.secret_string, var.defaults.secret_string, null)
  secret_binary                    = try(each.value.secret_binary, var.defaults.secret_binary, null)
  version_stages                   = try(each.value.version_stages, var.defaults.version_stages, null)
  create_random_password           = try(each.value.create_random_password, var.defaults.create_random_password, false)
  random_password_length           = try(each.value.random_password_length, var.defaults.random_password_length, 32)
  random_password_override_special = try(each.value.random_password_override_special, var.defaults.random_password_override_special, "!@#$%&*()-_=+[]{}<>:?")
  enable_rotation                  = try(each.value.enable_rotation, var.defaults.enable_rotation, false)
  rotation_lambda_arn              = try(each.value.rotation_lambda_arn, var.defaults.rotation_lambda_arn, "")
  rotation_rules                   = try(each.value.rotation_rules, var.defaults.rotation_rules, {})
}
