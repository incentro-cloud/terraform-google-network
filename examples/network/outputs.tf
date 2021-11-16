output "network_vpc" {
  value       = module.network.vpc
  description = "The VPC network."
}

output "network_subnets" {
  value       = module.network.subnets
  description = "The subnets."
}

output "network_routes" {
  value       = module.network.routes
  description = "The routes."
}

output "network_rules" {
  value       = module.network.rules
  description = "The rules."
}

output "network_connectors" {
  value       = module.network.connectors
  description = "The connectors."
}
