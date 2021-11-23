# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PEERINGS
# Submodule for creating network peerings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PEERINGS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_network_peering" "peerings" {
  for_each                            = { for peering in var.peerings : peering.name => peering }
  name                                = each.value.name
  network                             = each.value.network
  peer_network                        = each.value.peer_network
  export_custom_routes                = each.value.export_custom_routes
  import_custom_routes                = each.value.import_custom_routes
  export_subnet_routes_with_public_ip = each.value.export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = each.value.import_subnet_routes_with_public_ip
}