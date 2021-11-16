# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONNECTORS
# Submodule for creating serverless VPC access connectors.
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
# SERVERLESS VPC ACCESS CONNECTORS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_vpc_access_connector" "connectors" {
  provider       = google-beta
  for_each       = { for x in var.connectors : x.name => x }
  name           = each.value.name
  project        = var.project_id
  network        = each.value.network
  region         = each.value.region
  ip_cidr_range  = each.value.ip_cidr_range
  machine_type   = each.value.machine_type
  min_throughput = each.value.min_throughput
  max_throughput = each.value.max_throughput
  min_instances  = each.value.min_instances
  max_instances  = each.value.max_instances

  dynamic "subnet" {
    for_each = lookup(each.value, "subnet") == null ? [] : [each.value.subnet]

    content {
      name       = subnet.value.name
      project_id = lookup(subnet.value, "project_id", var.project_id)
    }
  }
}