# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NETWORK
# Module for creating a VPC network, subnets, routes, firewall rules, connectors, and peerings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# VPC NETWORK
# ---------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "./modules/vpc"

  create_network                  = var.create_network
  name                            = var.name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  project_id                      = var.project_id
  description                     = var.description
  shared_vpc                      = var.shared_vpc
  delete_default_routes_on_create = var.delete_default_routes_on_create
  mtu                             = var.mtu
}

# ---------------------------------------------------------------------------------------------------------------------
# SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  subnets = [
    for x in var.subnets : {
      name                     = x.name
      network                  = lookup(x, "network", module.vpc.vpc[0].name)
      ip_cidr_range            = x.ip_cidr_range
      region                   = x.region
      description              = lookup(x, "description", null)
      purpose                  = lookup(x, "purpose", null)
      role                     = lookup(x, "role", null)
      private_ip_google_access = lookup(x, "private_ip_google_access", false)
      log_config               = lookup(x, "log_config", null)
      secondary_ip_ranges      = lookup(x, "secondary_ip_ranges", [])
    }
  ]
}

module "subnets" {
  source = "./modules/subnets"

  project_id = var.project_id
  subnets    = local.subnets
}

# ---------------------------------------------------------------------------------------------------------------------
# ROUTES
# ---------------------------------------------------------------------------------------------------------------------

locals {
  routes = [
    for x in var.routes : {
      name                   = x.name
      network                = lookup(x, "network", module.vpc.vpc[0].name)
      description            = lookup(x, "description", null)
      tags                   = lookup(x, "tags", null)
      dest_range             = x.dest_range
      next_hop_gateway       = lookup(x, "next_hop_internet", false) == true ? "default-internet-gateway" : null
      next_hop_ip            = lookup(x, "next_hop_ip", null)
      next_hop_instance      = lookup(x, "next_hop_instance", null)
      next_hop_instance_zone = lookup(x, "next_hop_instance_zone", null)
      next_hop_vpn_tunnel    = lookup(x, "next_hop_vpn_tunnel", null)
      next_hop_ilb           = lookup(x, "next_hop_ilb", null)
      priority               = lookup(x, "priority", 1000)
    }
  ]
}

module "routes" {
  source = "./modules/routes"

  project_id = var.project_id
  routes     = local.routes
}

# ---------------------------------------------------------------------------------------------------------------------
# FIREWALL RULES
# ---------------------------------------------------------------------------------------------------------------------

locals {
  rules = [
    for x in var.rules : {
      name                    = x.name
      network                 = lookup(x, "network", module.vpc.vpc[0].name)
      direction               = x.direction
      priority                = lookup(x, "priority", 1000)
      description             = lookup(x, "description", null)
      ranges                  = lookup(x, "ranges", null)
      source_tags             = lookup(x, "source_tags", null)
      source_service_accounts = lookup(x, "source_service_accounts", null)
      target_tags             = lookup(x, "target_tags", null)
      target_service_accounts = lookup(x, "target_service_accounts", null)
      allow                   = lookup(x, "allow", [])
      deny                    = lookup(x, "deny", [])
      log_config              = lookup(x, "log_config", null)
    }
  ]
}

module "rules" {
  source = "./modules/rules"

  project_id = var.project_id
  rules      = local.rules
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORK PEERINGS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  peerings = [
    for x in var.peerings : {
      name         = x.name
      network      = x.network
      peer_network = x.peer_network
    }
  ]
}

module "peerings" {
  source = "./modules/peerings"

  project_id = var.project_id
  peerings   = local.peerings
}
