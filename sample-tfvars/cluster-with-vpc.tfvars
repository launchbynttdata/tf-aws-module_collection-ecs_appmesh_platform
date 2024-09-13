# This vars file creates an ECS cluster with a VPC, private and public subnets, VPC endpoints, and VPC endpoint security group.
# It also creates a cloud map namespace for service discovery and an instance of App Mesh
# Nat Gateway is not created in this example

logical_product_family  = "launch"
logical_product_service = "int"
environment             = "sandbox"
region                  = "us-east-2"
environment_number      = "000"

interface_vpc_endpoints = {
  ecrdkr = {
    service_name        = "ecr.dkr"
    private_dns_enabled = true
  }
  ecrapi = {
    service_name        = "ecr.api"
    private_dns_enabled = true
  }
  ecs = {
    service_name        = "ecs"
    private_dns_enabled = true
  }
  logs = {
    service_name        = "logs"
    private_dns_enabled = true
  }
  appmeshmgmt = {
    service_name        = "appmesh-envoy-management"
    private_dns_enabled = true
  }
}

gateway_vpc_endpoints = {
  s3 = {
    service_name        = "s3"
    private_dns_enabled = true
  }
}

vpce_security_group = {
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

namespace_name = "sandbox.launch.nttdata.local"

vpc = {
  vpc_name                   = "launch-int-sandbox-vpc"
  vpc_cidr                   = "10.20.0.0/16"
  private_subnet_cidr_ranges = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnet_cidr_ranges  = ["10.20.4.0/24", "10.20.5.0/24", "10.20.6.0/24"]
  availability_zones         = ["us-east-2a", "us-east-2b", "us-east-2c"]
  enable_nat_gateway         = false
}

create_vpc = true
