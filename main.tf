# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NETWORK
# Module for creating a VPC network, subnets, routes, rules, connectors, and peerings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# VPC NETWORK
# ---------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "./modules/vpc"

  create_vpc                      = var.create_vpc
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
    for subnet in var.subnets : {
      name                     = subnet.name
      network                  = lookup(subnet, "network", module.vpc.vpc[0].name)
      ip_cidr_range            = subnet.ip_cidr_range
      region                   = subnet.region
      description              = lookup(subnet, "description", null)
      purpose                  = lookup(subnet, "purpose", null)
      role                     = lookup(subnet, "role", null)
      private_ip_google_access = lookup(subnet, "private_ip_google_access", false)
      log_config               = lookup(subnet, "log_config", null)
      secondary_ip_ranges      = lookup(subnet, "secondary_ip_ranges", [])
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
    for route in var.routes : {
      name                   = route.name
      network                = lookup(route, "network", module.vpc.vpc[0].name)
      description            = lookup(route, "description", null)
      tags                   = lookup(route, "tags", null)
      dest_range             = lookup(route, "dest_range", "0.0.0.0/0")
      next_hop_gateway       = lookup(route, "next_hop_internet", false) == true ? "default-internet-gateway" : null
      next_hop_ip            = lookup(route, "next_hop_ip", null)
      next_hop_instance      = lookup(route, "next_hop_instance", null)
      next_hop_instance_zone = lookup(route, "next_hop_instance_zone", null)
      next_hop_vpn_tunnel    = lookup(route, "next_hop_vpn_tunnel", null)
      next_hop_ilb           = lookup(route, "next_hop_ilb", null)
      priority               = lookup(route, "priority", 1000)
    }
  ]
}

module "routes" {
  source = "./modules/routes"

  project_id = var.project_id
  routes     = local.routes
}

# ---------------------------------------------------------------------------------------------------------------------
# RULES
# ---------------------------------------------------------------------------------------------------------------------

locals {
  rules = [
    for rule in var.rules : {
      name                    = rule.name
      network                 = lookup(rule, "network", module.vpc.vpc[0].name)
      direction               = lookup(rule, "direction", "INGRESS")
      priority                = lookup(rule, "priority", 1000)
      description             = lookup(rule, "description", null)
      ranges                  = lookup(rule, "ranges", null)
      source_tags             = lookup(rule, "source_tags", null)
      source_service_accounts = lookup(rule, "source_service_accounts", null)
      target_tags             = lookup(rule, "target_tags", null)
      target_service_accounts = lookup(rule, "target_service_accounts", null)
      allow                   = lookup(rule, "allow", [])
      deny                    = lookup(rule, "deny", [])
      log_config              = lookup(rule, "log_config", null)
    }
  ]
}

module "rules" {
  source = "./modules/rules"

  project_id = var.project_id
  rules      = local.rules
}

# ---------------------------------------------------------------------------------------------------------------------
# CONNECTORS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  connectors = [
    for connector in var.connectors : {
      name           = lookup(connector, "name", "vpc-connector")
      network        = lookup(connector, "network", module.vpc.vpc[0].name)
      subnet         = lookup(connector, "subnet", null)
      region         = connector.region
      ip_cidr_range  = lookup(connector, "ip_cidr_range", null)
      machine_type   = lookup(connector, "machine_type", "e2-micro")
      min_throughput = lookup(connector, "min_throughput", 200)
      max_throughput = lookup(connector, "max_throughput", 300)
      min_instances  = lookup(connector, "min_instances", 2)
      max_instances  = lookup(connector, "max_instances", 3)
    }
  ]
}

module "connectors" {
  source = "./modules/connectors"

  project_id = var.project_id
  connectors = local.connectors
}

# ---------------------------------------------------------------------------------------------------------------------
# PEERINGS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  peerings = [
    for peering in var.peerings : {
      name                                = peering.name
      network                             = lookup(peering, "network", module.vpc.vpc[0].id)
      peer_network                        = peering.peer_network
      export_custom_routes                = lookup(peering, "export_custom_routes", false)
      import_custom_routes                = lookup(peering, "import_custom_routes", false)
      export_subnet_routes_with_public_ip = lookup(peering, "export_subnet_routes_with_public_ip", true)
      import_subnet_routes_with_public_ip = lookup(peering, "import_subnet_routes_with_public_ip", false)
    }
  ]
}

module "peerings" {
  source = "./modules/peerings"

  project_id = var.project_id
  peerings   = local.peerings
}

# ---------------------------------------------------------------------------------------------------------------------
# ROUTERS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  routers = [
    for router in var.routers : {
      name                               = router.name
      region                             = router.region
      network                            = lookup(router, "network", module.vpc.vpc[0].name)
      create_nat                         = lookup(router, "create_nat", false)
      source_subnetwork_ip_ranges_to_nat = lookup(router, "source_subnet_ip_ranges_to_nat", "ALL_SUBNETWORKS_ALL_IP_RANGES")
      nat_ip_allocate_option             = lookup(router, "nat_ip_allocate_option", "AUTO_ONLY")
    }
  ]
}

module "routers" {
  source = "./modules/routers"

  project_id = var.project_id
  routers    = local.routers
}
