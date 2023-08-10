variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Secret
################################################################################

variable "description" {
  description = "A description of the secret"
  type        = string
  default     = null
}

variable "force_overwrite_replica_secret" {
  description = "Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region"
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you need to reference a CMK in a different account, you can use only the key ARN. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named `aws/secretsmanager`"
  type        = string
  default     = null
}

variable "name" {
  description = "Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: `/_+=.@-`"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be `0` to force deletion without recovery or range from `7` to `30` days. The default value is `30`"
  type        = number
  default     = null
}

variable "replica" {
  description = "Configuration block to support secret replication"
  type        = map(any)
  default     = {}
}

################################################################################
# Policy
################################################################################

variable "create_policy" {
  description = "Determines whether a policy will be created"
  type        = bool
  default     = false
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = map(any)
  default     = {}
}

variable "block_public_policy" {
  description = "Makes an optional API call to Zelkova to validate the Resource Policy to prevent broad access to your secret"
  type        = bool
  default     = null
}

################################################################################
# Version
################################################################################

variable "ignore_secret_changes" {
  description = "Determines whether or not Terraform will ignore changes made externally to `secret_string` or `secret_binary`. Changing this value after creation is a destructive operation"
  type        = bool
  default     = false
}

variable "secret_string" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if `secret_binary` is not set"
  type        = string
  default     = null
}

variable "secret_binary" {
  description = "Specifies binary data that you want to encrypt and store in this version of the secret. This is required if `secret_string` is not set. Needs to be encoded to base64"
  type        = string
  default     = null
}

variable "version_stages" {
  description = "Specifies a list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret"
  type        = list(string)
  default     = null
}

variable "create_random_password" {
  description = "Determines whether a random password will be generated"
  type        = bool
  default     = false
}

variable "random_password_length" {
  description = "The length of the generated random password"
  type        = number
  default     = 32
}

variable "random_password_override_special" {
  description = "Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument"
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?"
}

################################################################################
# Rotation
################################################################################

variable "enable_rotation" {
  description = "Determines whether secret rotation is enabled"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "Specifies the ARN of the Lambda function that can rotate the secret"
  type        = string
  default     = ""
}

variable "rotation_rules" {
  description = "A structure that defines the rotation configuration for this secret"
  type        = map(any)
  default     = {}
}
