module "wrapper" {
  source = "../"

  for_each = var.items

  block_public_policy              = try(each.value.block_public_policy, var.defaults.block_public_policy, null)
  create                           = try(each.value.create, var.defaults.create, true)
  create_policy                    = try(each.value.create_policy, var.defaults.create_policy, false)
  create_random_password           = try(each.value.create_random_password, var.defaults.create_random_password, false)
  description                      = try(each.value.description, var.defaults.description, null)
  enable_rotation                  = try(each.value.enable_rotation, var.defaults.enable_rotation, false)
  force_overwrite_replica_secret   = try(each.value.force_overwrite_replica_secret, var.defaults.force_overwrite_replica_secret, null)
  ignore_secret_changes            = try(each.value.ignore_secret_changes, var.defaults.ignore_secret_changes, false)
  kms_key_id                       = try(each.value.kms_key_id, var.defaults.kms_key_id, null)
  name                             = try(each.value.name, var.defaults.name, null)
  name_prefix                      = try(each.value.name_prefix, var.defaults.name_prefix, null)
  override_policy_documents        = try(each.value.override_policy_documents, var.defaults.override_policy_documents, [])
  policy_statements                = try(each.value.policy_statements, var.defaults.policy_statements, null)
  random_password_length           = try(each.value.random_password_length, var.defaults.random_password_length, 32)
  random_password_override_special = try(each.value.random_password_override_special, var.defaults.random_password_override_special, "!@#$%&*()-_=+[]{}<>:?")
  recovery_window_in_days          = try(each.value.recovery_window_in_days, var.defaults.recovery_window_in_days, null)
  region                           = try(each.value.region, var.defaults.region, null)
  replica                          = try(each.value.replica, var.defaults.replica, null)
  rotate_immediately               = try(each.value.rotate_immediately, var.defaults.rotate_immediately, null)
  rotation_lambda_arn              = try(each.value.rotation_lambda_arn, var.defaults.rotation_lambda_arn, "")
  rotation_rules                   = try(each.value.rotation_rules, var.defaults.rotation_rules, null)
  secret_binary                    = try(each.value.secret_binary, var.defaults.secret_binary, null)
  secret_string                    = try(each.value.secret_string, var.defaults.secret_string, null)
  secret_string_wo                 = try(each.value.secret_string_wo, var.defaults.secret_string_wo, null)
  secret_string_wo_version         = try(each.value.secret_string_wo_version, var.defaults.secret_string_wo_version, null)
  source_policy_documents          = try(each.value.source_policy_documents, var.defaults.source_policy_documents, [])
  tags                             = try(each.value.tags, var.defaults.tags, {})
  version_stages                   = try(each.value.version_stages, var.defaults.version_stages, null)
}
