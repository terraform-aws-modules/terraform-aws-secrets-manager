################################################################################
# Secrets
################################################################################

output "secret_arns" {
  description = "ARNs of the secrets created by this example, keyed by secret name."
  value       = { for k, v in aws_secretsmanager_secret.this : k => v.arn }
}

output "secret_names" {
  description = "Names of the secrets created by this example."
  value       = [for s in aws_secretsmanager_secret.this : s.name]
}
