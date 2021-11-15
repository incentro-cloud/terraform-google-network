output "vpc" {
  value       = var.create_network ? module.vpc.vpc : null
  description = "The VPC network."
}

output "vpc_name" {
  value       = var.create_network ? module.vpc.vpc[0].name : null
  description = "The name of the VPC network."
}

output "subnets" {
  value       = module.subnets.subnets
  description = "The subnets."
}

output "subnets_names" {
  value       = [for x in module.subnets.subnets : x.name]
  description = "The names of the subnets."
}

output "routes" {
  value       = module.routes.routes
  description = "The routes."
}

output "routes_names" {
  value       = [for x in module.routes.routes : x.name]
  description = "The names of the routes."
}

output "rules" {
  value       = module.rules.rules
  description = "The firewall rules."
}

output "rules_names" {
  value       = [for x in module.rules.rules : x.name]
  description = "The names of the firewall rules."
}

output "peerings" {
  value       = module.peerings.peerings
  description = "The peerings."
}

output "peerings_names" {
  value       = [for x in module.peerings.peerings : x.name]
  description = "The names of the peerings."
}
