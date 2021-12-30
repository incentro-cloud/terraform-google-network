# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ROUTERS
# Submodule for creating routers.
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
# ROUTERS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_router" "routers" {
  for_each = { for router in var.routers : router.name => router }
  name     = each.value.name
  project  = var.project_id
  region   = each.value.region
  network  = each.value.network
}

resource "google_compute_router_nat" "routers_nats" {
  for_each                           = { for router in var.routers : router.name => router if router.create_nat }
  name                               = "${each.value.name}-nat"
  project                            = var.project_id
  router                             = google_compute_router.routers[each.value.name].name
  region                             = each.value.region
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat
  nat_ip_allocate_option             = each.value.nat_ip_allocate_option
}
