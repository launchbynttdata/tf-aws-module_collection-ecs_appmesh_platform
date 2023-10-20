# tf-aws-wrapper_module-ecs_appmesh_platform

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module creates a ECS Platform with App Mesh enabled. The following resources are created
- VPC endpoints (optional)
- VPC endpoint Security group (optional)
- ECS Fargate Cluster
- CloudMap Namespace
- App Mesh

## Usage
A sample variable file `example.tfvars` is available in the root directory which can be used to test this module. User needs to follow the below steps to execute this module
1. Update the `example.tfvars` to manually enter values for all fields marked within `<>` to make the variable file usable
2. Create a file `provider.tf` with the below contents
   ```
    provider "aws" {
      profile = "<profile_name>"
      region  = "<region_name>"
    }
    ```
   If using `SSO`, make sure you are logged in `aws sso login --profile <profile_name>`
3. Make sure terraform binary is installed on your local. Use command `type terraform` to find the installation location. If you are using `asdf`, you can run `asfd install` and it will install the correct terraform version for you. `.tool-version` contains all the dependencies.
4. Run the `terraform` to provision infrastructure on AWS
    ```
    # Initialize
    terraform init
    # Plan
    terraform plan -var-file example.tfvars
    # Apply (this is create the actual infrastructure)
    terraform apply -var-file example.tfvars -auto-approve
   ```
## Known Issues

1. NA

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `aws_env.sh` file on local workstation. Developer would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `aws` specific. If primitive/segment under development uses any other cloud provider than AWS, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "aws" {
  profile = "<profile_name>"
  region  = "<region_name>"
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests

# Know Issues
Currently, the `encrypt at transit` is not supported in terraform. There is an open issue for this logged with Hashicorp - https://github.com/hashicorp/terraform-provider-aws/pull/26987

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group_vpce"></a> [security\_group\_vpce](#module\_security\_group\_vpce) | terraform-aws-modules/security-group/aws | ~> 4.17.1 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/nexient-llc/tf-module-resource_name.git | 0.1.0 |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | ~> 4.1.3 |
| <a name="module_interface_endpoints"></a> [interface\_endpoints](#module\_interface\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | ~> 3.19.0 |
| <a name="module_gateway_endpoints"></a> [gateway\_endpoints](#module\_gateway\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | ~> 3.19.0 |
| <a name="module_namespace"></a> [namespace](#module\_namespace) | git::https://github.com/nexient-llc/tf-aws-module-private_dns_namespace.git | 0.1.0 |
| <a name="module_app_mesh"></a> [app\_mesh](#module\_app\_mesh) | git::https://github.com/nexient-llc/tf-aws-module-appmesh.git | 0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for the provisioned resources. | `string` | `"platform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-module-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "app_mesh": {<br>    "max_length": 60,<br>    "name": "mesh"<br>  },<br>  "ecs_cluster": {<br>    "max_length": 60,<br>    "name": "fargate"<br>  },<br>  "namespace": {<br>    "max_length": 60,<br>    "name": "ns"<br>  },<br>  "vpce_sg": {<br>    "max_length": 60,<br>    "name": "vpce-sg"<br>  }<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the VPC where infrastructure will be provisioned | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnets | `list(string)` | `[]` | no |
| <a name="input_gateway_vpc_endpoints"></a> [gateway\_vpc\_endpoints](#input\_gateway\_vpc\_endpoints) | List of VPC endpoints to be created. AWS currently only supports S3 and DynamoDB gateway interfaces | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    route_table_ids     = optional(list(string))<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_interface_vpc_endpoints"></a> [interface\_vpc\_endpoints](#input\_interface\_vpc\_endpoints) | List of VPC endpoints to be created | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route tables for Gateway VPC endpoints | `list(string)` | `[]` | no |
| <a name="input_vpce_security_group"></a> [vpce\_security\_group](#input\_vpce\_security\_group) | Default security group to be attached to all VPC endpoints | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_container_insights_enabled"></a> [container\_insights\_enabled](#input\_container\_insights\_enabled) | Whether to enable container Insights or not | `bool` | `true` | no |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | The Cloud Map namespace to be created. Should be a valid domain name. Example test.example.local | `string` | `""` | no |
| <a name="input_namespace_description"></a> [namespace\_description](#input\_namespace\_description) | Description for the Cloud Map Namespace | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of custom tags to be attached to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface_endpoints"></a> [interface\_endpoints](#output\_interface\_endpoints) | A map of interface VPC endpoint IDs |
| <a name="output_gateway_endpoints"></a> [gateway\_endpoints](#output\_gateway\_endpoints) | A map of gateway VPC endpoint IDs |
| <a name="output_resource_names"></a> [resource\_names](#output\_resource\_names) | A map of resource\_name\_types to generated resource names used in this module |
| <a name="output_vpce_sg_id"></a> [vpce\_sg\_id](#output\_vpce\_sg\_id) | The ID of the VPC Endpoint Security Group |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | # CloudMap related outputs |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | ID of the Cloud Map Namespace |
| <a name="output_namespace_arn"></a> [namespace\_arn](#output\_namespace\_arn) | ARN of the Cloud Map Namespace |
| <a name="output_namespace_hosted_zone"></a> [namespace\_hosted\_zone](#output\_namespace\_hosted\_zone) | Hosted Zone of Cloud Map Namespace |
| <a name="output_app_mesh_id"></a> [app\_mesh\_id](#output\_app\_mesh\_id) | ID of the App Mesh |
| <a name="output_app_mesh_arn"></a> [app\_mesh\_arn](#output\_app\_mesh\_arn) | ARN of the App Mesh |
| <a name="output_fargate_arn"></a> [fargate\_arn](#output\_fargate\_arn) | The ARN of the ECS fargate cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
