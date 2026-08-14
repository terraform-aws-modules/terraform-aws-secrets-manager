variable "secrets" {
  description = "Set of secret names to create in Secrets Manager. Each name is used both as the aws_secretsmanager_secret 'name' and as the for_each key driving the ephemeral random_password generated for it."
  type        = set(string)
  default     = ["secret1", "secret2", "secret3"]
}
