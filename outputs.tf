output "vpc_id" {
  value       = var.create_vpc ? module.vpc.vpc[0].id : null
  description = "The VPC network."
}

output "vpc_name" {
  value       = var.create_vpc ? module.vpc.vpc[0].name : null
  description = "The name of the VPC network."
}

output "subnets_names" {
  value       = { for subnet in module.subnets.subnets : subnet.name => subnet.name }
  description = "The names of the subnets."
}

output "routes_names" {
  value       = { for route in module.routes.routes : route.name => route.name }
  description = "The names of the routes."
}

output "rules_names" {
  value       = { for rule in module.rules.rules : rule.name => rule.name }
  description = "The names of the firewall rules."
}

output "connectors_names" {
  value       = { for connector in module.connectors.connectors : connector.name => connector.name }
  description = "The names of the connectors."
}

output "peerings_names" {
  value       = { for peering in module.peerings.peerings : peering.name => peering.name }
  description = "The names of the peerings."
}
