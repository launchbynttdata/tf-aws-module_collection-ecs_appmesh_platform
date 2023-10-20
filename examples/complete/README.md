# Complete Example
This example demonstrates the creation of a `ECS Platform` with App Mesh enabled. It creates all its dependencies like VPC, Subnets, Security Groups etc.

## Provider requirements
Make sure a `provider.tf` file is created with the below contents inside the `examples/complete` directory
```shell
provider "aws" {
  profile = "<profile_name>"
  region  = "<aws_region>"
}
# Used to create a random integer postfix for aws resources
provider "random" {}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0.0 |
| <a name="module_ecs_platform"></a> [ecs\_platform](#module\_ecs\_platform) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.priority](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for the provisioned resources. | `string` | `"example"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.1.0.0/16"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet cidrs | `list` | <pre>[<br>  "10.1.1.0/24",<br>  "10.1.2.0/24",<br>  "10.1.3.0/24"<br>]</pre> | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for the VPC | `list` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b",<br>  "us-east-2c"<br>]</pre> | no |
| <a name="input_interface_vpc_endpoints"></a> [interface\_vpc\_endpoints](#input\_interface\_vpc\_endpoints) | List of VPC endpoints to be created | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_gateway_vpc_endpoints"></a> [gateway\_vpc\_endpoints](#input\_gateway\_vpc\_endpoints) | List of VPC endpoints to be created | <pre>map(object({<br>    service_name        = string<br>    subnet_names        = optional(list(string), [])<br>    private_dns_enabled = optional(bool, false)<br>    tags                = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_vpce_security_group"></a> [vpce\_security\_group](#input\_vpce\_security\_group) | Default security group to be attached to all VPC endpoints | <pre>object({<br>    ingress_rules            = optional(list(string))<br>    ingress_cidr_blocks      = optional(list(string))<br>    ingress_with_cidr_blocks = optional(list(map(string)))<br>    egress_rules             = optional(list(string))<br>    egress_cidr_blocks       = optional(list(string))<br>    egress_with_cidr_blocks  = optional(list(map(string)))<br>  })</pre> | `null` | no |
| <a name="input_container_insights_enabled"></a> [container\_insights\_enabled](#input\_container\_insights\_enabled) | Whether to enable container Insights or not | `bool` | `true` | no |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | The Cloud Map namespace to be created. Should be a valid domain name. Example test.example.local | `string` | `""` | no |
| <a name="input_namespace_description"></a> [namespace\_description](#input\_namespace\_description) | Description for the Cloud Map Namespace | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of custom tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_random_int"></a> [random\_int](#output\_random\_int) | Random Int postfix |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC Id for the example |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | # CloudMap related outputs |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | ID of the Cloud Map Namespace |
| <a name="output_namespace_arn"></a> [namespace\_arn](#output\_namespace\_arn) | ARN of the Cloud Map Namespace |
| <a name="output_namespace_hosted_zone"></a> [namespace\_hosted\_zone](#output\_namespace\_hosted\_zone) | Hosted Zone of Cloud Map Namespace |
| <a name="output_app_mesh_id"></a> [app\_mesh\_id](#output\_app\_mesh\_id) | ID of the App Mesh |
| <a name="output_app_mesh_arn"></a> [app\_mesh\_arn](#output\_app\_mesh\_arn) | ARN of the App Mesh |
| <a name="output_fargate_arn"></a> [fargate\_arn](#output\_fargate\_arn) | The ARN of the ECS fargate cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->