# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SUBNETS
# Submodule for creating subnets.
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
# SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for x in var.subnets : "${x.region}/${x.name}" => x }
  name                     = each.value.name
  project                  = var.project_id
  description              = each.value.description
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  private_ip_google_access = each.value.private_ip_google_access
  network                  = each.value.network

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]

    content {
      aggregation_interval = lookup(log_config.value, "aggregation_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(log_config.value, "flow_sampling", "0.5")
      metadata             = lookup(log_config.value, "flow_metadata", "INCLUDE_ALL_METADATA")
    }
  }

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ip_ranges", [])

    content {
      range_name    = lookup(secondary_ip_range.value, "range_name", null)
      ip_cidr_range = lookup(secondary_ip_range.value, "ip_cidr_range", null)
    }
  }
}
