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

resource "random_integer" "priority" {
  min = 10000
  max = 50000
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name                 = local.vpc_name
  cidr                 = var.vpc_cidr
  private_subnets      = var.private_subnets
  azs                  = var.availability_zones
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

module "ecs_platform" {
  source = "../.."

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  # Need to inject route_table_ids for gateway endpoints
  gateway_vpc_endpoints   = var.gateway_vpc_endpoints
  interface_vpc_endpoints = var.interface_vpc_endpoints
  route_table_ids         = [module.vpc.default_route_table_id]

  logical_product_family     = var.logical_product_family
  logical_product_service    = local.logical_product_service
  vpce_security_group        = var.vpce_security_group
  region                     = var.region
  environment                = var.environment
  environment_number         = var.environment_number
  resource_number            = var.resource_number
  container_insights_enabled = var.container_insights_enabled

  namespace_name        = local.namespace_name
  namespace_description = var.namespace_description

  tags = var.tags
}
