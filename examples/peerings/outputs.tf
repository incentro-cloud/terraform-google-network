output "network_01_vpc" {
  value       = module.network_01.vpc
  description = "The name of the VPC network."
}

output "network_01_subnets" {
  value       = module.network_01.subnets
  description = "The names of the subnets."
}

output "network_01_peerings" {
  value = module.network_01_peerings.peerings
}

output "network_02_vpc" {
  value       = module.network_02.vpc
  description = "The name of the VPC network."
}

output "network_02_subnets" {
  value       = module.network_02.subnets
  description = "The names of the subnets."
}

output "network_02_peerings" {
  value = module.network_02_peerings.peerings
}

output "network_03_vpc" {
  value       = module.network_03.vpc
  description = "The name of the VPC network."
}

output "network_03_subnets" {
  value       = module.network_03.subnets
  description = "The names of the subnets."
}

output "network_03_peerings" {
  value = module.network_03_peerings.peerings
}