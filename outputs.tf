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

## VPC related outputs

output "interface_endpoints" {
  description = "A map of interface VPC endpoint IDs"
  value       = { for k, v in module.interface_endpoints.endpoints : k => v.id }
}

output "gateway_endpoints" {
  description = "A map of gateway VPC endpoint IDs"
  value       = { for k, v in module.gateway_endpoints.endpoints : k => v.id }
}

output "resource_names" {
  description = "A map of resource_name_types to generated resource names used in this module"
  value       = { for k, v in var.resource_names_map : k => module.resource_names[k].standard }
}

output "vpce_sg_id" {
  description = "The ID of the VPC Endpoint Security Group"
  value       = try(module.security_group_vpce[0].security_group_id, "")
}

## CloudMap related outputs
output "namespace_name" {
  value = module.namespace.name
}

output "namespace_id" {
  description = "ID of the Cloud Map Namespace"
  value       = module.namespace.id
}

output "namespace_arn" {
  description = "ARN of the Cloud Map Namespace"
  value       = module.namespace.arn
}

output "namespace_hosted_zone" {
  description = "Hosted Zone of Cloud Map Namespace"
  value       = module.namespace.hosted_zone
}

## App Mesh related outputs

output "app_mesh_id" {
  description = "ID of the App Mesh"
  value       = module.app_mesh.id
}

output "app_mesh_arn" {
  description = "ARN of the App Mesh"
  value       = module.app_mesh.arn
}

## ECS related outputs

output "fargate_arn" {
  description = "The ARN of the ECS fargate cluster"
  value       = module.ecs.cluster_arn
}
