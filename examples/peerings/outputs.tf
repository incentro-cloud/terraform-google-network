output "network_vpc" {
  value       = module.network.vpc
  description = "The name of the VPC network."
}

output "network_subnets" {
  value       = module.network.subnets
  description = "The names of the subnets."
}

output "network_peerings" {
  value = module.network.peerings
}

output "network_peer_vpc" {
  value       = module.network_peer.vpc
  description = "The name of the VPC network."
}

output "network_peer_subnets" {
  value       = module.network_peer.subnets
  description = "The names of the subnets."
}
