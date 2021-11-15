# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# FIREWALL RULES
# Submodule for creating firewall rules.
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
# FIREWALL RULES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "rules" {
  for_each                = { for x in var.rules : x.name => x }
  name                    = each.value.name
  description             = each.value.description
  direction               = each.value.direction
  network                 = each.value.network
  project                 = var.project_id
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]

    content {
      metadata = lookup(log_config.value, "metadata", "INCLUDE_ALL_METADATA")
    }
  }

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])

    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])

    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }
}
