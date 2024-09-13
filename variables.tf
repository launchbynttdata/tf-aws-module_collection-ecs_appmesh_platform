// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "ecs"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "us-east-2"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    ecs_cluster = {
      name       = "fargate"
      max_length = 60
    }
    vpce_sg = {
      name       = "vpcesg"
      max_length = 60
    }
    namespace = {
      name       = "ns"
      max_length = 60
    }
    app_mesh = {
      name       = "mesh"
      max_length = 60
    }
  }
}

### VPC related variables
variable "create_vpc" {
  description = "Whether to create the VPC or not. Set this value to `true` to create a new VPC for ECS cluster. Default is `false`"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID of the VPC where infrastructure will be provisioned"
  type        = string
  default     = null
}

variable "private_subnets" {
  description = "List of private subnets. Required when create_vpc=false. Will be ignored when create_vpc=true"
  type        = list(string)
  default     = []
}

variable "vpc" {
  description = <<EOT
    VPC related variables. Required when create_vpc=true.
    Public subnets are required when user wants to provision internet facing ALBs also when enable_nat_gateway=true,
    If single_nat_gateway=true, 1 Nat Gateway will be created, else if one_nat_gateway_per_az=true, 1 Nat Gateway per AZ
    will be created, else that many Nat gateways will be created as the number of max(public, private) subnets
  EOT
  type = object({
    vpc_name                       = string
    vpc_cidr                       = string
    private_subnet_cidr_ranges     = list(string)
    public_subnet_cidr_ranges      = optional(list(string), [])
    availability_zones             = list(string)
    default_security_group_ingress = optional(list(map(string)), [])
    enable_nat_gateway             = optional(bool, false)
    single_nat_gateway             = optional(bool, true)
    one_nat_gateway_per_az         = optional(bool, false)
  })

  default = null
}

### VPC Endpoints related variables
variable "gateway_vpc_endpoints" {
  description = "List of VPC endpoints to be created. AWS currently only supports S3 and DynamoDB gateway interfaces"
  type = map(object({
    service_name        = string
    subnet_names        = optional(list(string), [])
    private_dns_enabled = optional(bool, false)
    route_table_ids     = optional(list(string))
    tags                = optional(map(string), {})
  }))

  default = {}
}

variable "interface_vpc_endpoints" {
  description = <<EOT
    List of VPC endpoints to be created. Must create endpoints for all AWS services that the ECS services
    needs to communicate over the private network. For example: ECR, CloudWatch, AppMesh etc. In absence of
    NAT gateway, pull images from ECR too needs private endpoint.
  EOT
  type = map(object({
    service_name        = string
    subnet_names        = optional(list(string), [])
    private_dns_enabled = optional(bool, false)
    tags                = optional(map(string), {})
  }))

  default = {}
}

variable "route_table_ids" {
  description = "List of route tables for Gateway VPC endpoints"
  type        = list(string)
  default     = []
}

variable "vpce_security_group" {
  description = "Default security group to be attached to all VPC endpoints. Must allow relevant ingress and egress traffic."
  type = object({
    ingress_rules            = optional(list(string))
    ingress_cidr_blocks      = optional(list(string))
    ingress_with_cidr_blocks = optional(list(map(string)))
    egress_rules             = optional(list(string))
    egress_cidr_blocks       = optional(list(string))
    egress_with_cidr_blocks  = optional(list(map(string)))
  })

  default = null
}

### ECS Cluster related variables
variable "container_insights_enabled" {
  description = "Whether to enable container Insights or not. Default is true"
  type        = bool
  default     = true
}

### Cloud Map Namespace related variables
variable "namespace_name" {
  description = <<EOT
    The Cloud Map namespace to be created. Should be a valid domain name. Example test.example.local. Mostly used for
    service discovery and AppMesh
  EOT
  type        = string
  default     = ""
}

variable "namespace_description" {
  description = "Description for the Cloud Map Namespace"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of custom tags to be attached to resources"
  type        = map(string)
  default     = {}
}
