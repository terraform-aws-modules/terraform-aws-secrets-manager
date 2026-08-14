# Ephemeral Values + for_each: Direct Resource Workaround

This example demonstrates using Terraform's ephemeral values and write-only
arguments to generate and store Secrets Manager secret values that are never
written to state — combined with `for_each` to create multiple secrets at
once.

## Why this doesn't use the module wrapper

The `terraform-aws-secrets-manager` module's `secret_string_wo` variable is
correctly declared `ephemeral = true`, so passing an ephemeral value into a
*single* module call works fine. In practice, combining that with `for_each`
on the `module` block itself breaks — this was reported against the module
in issue #28 and is a real, reproducible limitation. I haven't traced this
to a specific documented root cause in Terraform's internals; I'm noting it
as an observed limitation, not asserting why it happens at the Terraform
core level.

The workaround here skips the module wrapper entirely and calls the
underlying `aws_secretsmanager_secret` / `aws_secretsmanager_secret_version`
resources directly, each with its own `for_each`. This is fully supported —
HashiCorp's own `for_each` documentation shows the same pattern on a plain
resource block. You lose the module's extras (IAM policy attachment,
rotation config) for these specific secrets, but keep the core security
property: the generated value is never persisted to the state file.

## What it creates

For each name in `var.secrets` (default: `secret1`, `secret2`, `secret3`):

- An `ephemeral "random_password"` — a 32-character random value that exists
  only for the duration of the plan/apply, never written to state
- An `aws_secretsmanager_secret` — the secret container
- An `aws_secretsmanager_secret_version` — writes the ephemeral password
  into the secret via the write-only `secret_string_wo` argument

## Notes on the code

- `var.secrets` is a `set(string)`, so `each.key` and `each.value` are
  identical for each iteration — that's expected for sets. If you need a
  name *and* a separate label or purpose per secret, a `map(string)` would
  be a better fit than a set.
- `secret_string_wo_version` is hardcoded to `1`. This is required —
  Terraform can't diff a value it never persists to state, so version bumps
  are how you signal "this value changed, write it again." A real rotation
  workflow would drive this from something that actually changes (a
  timestamp, a rotation-trigger variable, a CI pipeline input).
- The `random` provider and the `ephemeral "random_password"` block are
  both used by this example, but `terraform-docs` doesn't currently
  surface `ephemeral` blocks in its Resources or Providers tables below —
  so `random` won't appear there even though it's a real dependency.

## Tested against

**floci** (a local AWS emulator, `floci/floci:1.6.0`): `terraform apply`
created all three secrets with real, distinct 32-character random values,
confirmed via independent `aws secretsmanager get-secret-value` calls (not
just Terraform's own reported success). `terraform destroy` tore them down
cleanly.

**Real AWS** (Secrets Manager, `us-east-1`): full `plan` → `apply` → verify
→ `destroy` cycle, with each secret independently confirmed via the AWS CLI
before and after — 32-character values with high character diversity (24–27
unique characters per secret, i.e. genuinely random, not a placeholder or
degenerate pattern). After `terraform destroy`, all three secrets were
force-deleted without the default 30-day recovery window to leave the
account clean rather than sitting in pending-deletion for a month. No
standing resources or costs remain.

Note that this example may create resources which will incur monetary
charges on your AWS bill. Run `terraform destroy` when you no longer need
these resources.

## Usage

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Set of secret names to create in Secrets Manager. Each name is used both as the aws\_secretsmanager\_secret 'name' and as the for\_each key driving the ephemeral random\_password generated for it. | `set(string)` | <pre>[<br/>  "secret1",<br/>  "secret2",<br/>  "secret3"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | ARNs of the secrets created by this example, keyed by secret name. |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Names of the secrets created by this example. |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-secrets-manager/blob/master/LICENSE).
