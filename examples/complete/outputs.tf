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

output "random_int" {
  description = "Random Int postfix"
  value       = random_integer.priority.result
}

output "vpc_id" {
  description = "VPC Id for the example"
  value       = module.vpc.vpc_id
}

output "resource_names" {
  value = module.ecs_platform.resource_names
}

## CloudMap related outputs
output "namespace_name" {
  value = module.ecs_platform.namespace_name
}

output "namespace_id" {
  description = "ID of the Cloud Map Namespace"
  value       = module.ecs_platform.namespace_id
}

output "namespace_arn" {
  description = "ARN of the Cloud Map Namespace"
  value       = module.ecs_platform.namespace_arn
}

output "namespace_hosted_zone" {
  description = "Hosted Zone of Cloud Map Namespace"
  value       = module.ecs_platform.namespace_hosted_zone
}

## App Mesh related outputs

output "app_mesh_id" {
  description = "ID of the App Mesh"
  value       = module.ecs_platform.app_mesh_id
}

output "app_mesh_arn" {
  description = "ARN of the App Mesh"
  value       = module.ecs_platform.app_mesh_arn
}

## ECS related outputs

output "fargate_arn" {
  description = "The ARN of the ECS fargate cluster"
  value       = module.ecs_platform.fargate_arn
}
