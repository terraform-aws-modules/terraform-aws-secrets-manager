################################################################################
# Secret
################################################################################

output "secret_arn" {
  description = "The ARN of the secret"
  value       = try(aws_secretsmanager_secret.this[0].arn, null)
}

output "secret_id" {
  description = "The ID of the secret"
  value       = try(aws_secretsmanager_secret.this[0].id, null)
}

output "secret_name" {
  description = "The name of the secret"
  value       = try(aws_secretsmanager_secret.this[0].name, null)
}

output "secret_replica" {
  description = "Attributes of the replica created"
  value       = try(aws_secretsmanager_secret.this[0].replica, null)
}

output "secret_string" {
  description = "The secret string"
  sensitive   = true
  value       = try(aws_secretsmanager_secret_version.this[0].secret_string, aws_secretsmanager_secret_version.ignore_changes[0].secret_string, null)
}

output "secret_binary" {
  description = "The secret binary"
  sensitive   = true
  value       = try(aws_secretsmanager_secret_version.this[0].secret_binary, aws_secretsmanager_secret_version.ignore_changes[0].secret_binary, null)
}

################################################################################
# Version
################################################################################

output "secret_version_id" {
  description = "The unique identifier of the version of the secret"
  value       = try(aws_secretsmanager_secret_version.this[0].version_id, aws_secretsmanager_secret_version.ignore_changes[0].version_id, null)
}
