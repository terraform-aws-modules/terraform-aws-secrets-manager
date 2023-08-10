# Complete AWS Secrets Manager Example

Configuration in this directory creates:

- Standard Secrets Manager Secret
- Secrets Manager Secret with rotation enabled

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

If you wish to test the rotated secret, after provisioning the resources you can go into the console and under the rotated secret click `Rotate secret immediately`. This will trigger the lambda function to rotate the secret. You can then go to the `Secret value` tab and click `Retrieve secret value` to see the new secret value.

After rotating the secret, you can run `terraform plan` and see that there are no detected changes.

:warning: Replicated secrets are not cleaned up by Terraform. You will need to manually delete these secrets. Ref: https://github.com/hashicorp/terraform-provider-aws/issues/23316

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 6.0 |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ../.. | n/a |
| <a name="module_secrets_manager_disabled"></a> [secrets\_manager\_disabled](#module\_secrets\_manager\_disabled) | ../.. | n/a |
| <a name="module_secrets_manager_rotate"></a> [secrets\_manager\_rotate](#module\_secrets\_manager\_rotate) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rotate_secret_arn"></a> [rotate\_secret\_arn](#output\_rotate\_secret\_arn) | The ARN of the secret |
| <a name="output_rotate_secret_id"></a> [rotate\_secret\_id](#output\_rotate\_secret\_id) | The ID of the secret |
| <a name="output_rotate_secret_replica"></a> [rotate\_secret\_replica](#output\_rotate\_secret\_replica) | Attributes of the replica created |
| <a name="output_rotate_secret_version_id"></a> [rotate\_secret\_version\_id](#output\_rotate\_secret\_version\_id) | The unique identifier of the version of the secret |
| <a name="output_standard_secret_arn"></a> [standard\_secret\_arn](#output\_standard\_secret\_arn) | The ARN of the secret |
| <a name="output_standard_secret_id"></a> [standard\_secret\_id](#output\_standard\_secret\_id) | The ID of the secret |
| <a name="output_standard_secret_replica"></a> [standard\_secret\_replica](#output\_standard\_secret\_replica) | Attributes of the replica created |
| <a name="output_standard_secret_version_id"></a> [standard\_secret\_version\_id](#output\_standard\_secret\_version\_id) | The unique identifier of the version of the secret |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-secrets-manager/blob/master/LICENSE).
