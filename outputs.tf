output "vpc" {
  value       = var.create_vpc ? module.vpc.vpc[0] : null
  description = "The VPC network."
}

output "vpc_name" {
  value       = var.create_vpc ? module.vpc.vpc[0].name : null
  description = "The name of the VPC network."
}

output "subnets" {
  value       = module.subnets.subnets
  description = "The subnets."
}

output "subnets_names" {
  value       = { for subnet in module.subnets.subnets : subnet.name => lower(subnet.name) }
  description = "The names of the subnets."
}

output "routes" {
  value       = module.routes.routes
  description = "The routes."
}

output "routes_names" {
  value       = [for route in module.routes.routes : route.name]
  description = "The names of the routes."
}

output "rules" {
  value       = module.rules.rules
  description = "The firewall rules."
}

output "rules_names" {
  value       = [for rule in module.rules.rules : rule.name]
  description = "The names of the firewall rules."
}

output "connectors" {
  value       = module.connectors.connectors
  description = "The connectors."
}

output "connectors_names" {
  value       = [for connector in module.connectors.connectors : connector.name]
  description = "The names of the connectors."
}

output "peerings" {
  value       = module.peerings.peerings
  description = "The peerings."
}

output "peerings_names" {
  value       = [for peering in module.peerings.peerings : peering.name]
  description = "The names of the peerings."
}
