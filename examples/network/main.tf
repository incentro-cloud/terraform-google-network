# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC NETWORK, SUBNET, ROUTE, RULES, AND CONNECTOR
# ---------------------------------------------------------------------------------------------------------------------

module "network" {
  source = "../../"

  project_id                      = var.project_id
  name                            = "vpc-network"
  delete_default_routes_on_create = true

  subnets = [
    {
      name                     = "default"
      ip_cidr_range            = "10.0.1.0/24"
      region                   = "europe-west1"
      private_ip_google_access = true

      log_config = {
        aggregation_interval = "INTERVAL_5_SEC"
        flow_sampling        = "0.5"
        metadata             = "INCLUDE_ALL_METADATA"
      }

      secondary_ip_ranges = [
        {
          range_name    = "default-range-01"
          ip_cidr_range = "10.0.2.0/24"
        }
      ]
    }
  ]

  routes = [
    {
      name              = "internet-egress"
      description       = "Route through default internet gateway to access internet"
      dest_range        = "0.0.0.0/0"
      tags              = ["internet"]
      next_hop_internet = true
    }
  ]

  rules = [
    {
      name        = "allow-connector-to-serverless-egress"
      direction   = "EGRESS"
      ranges      = ["107.178.230.64/26", "35.199.224.0/19"]
      target_tags = ["vpc-connector"]

      allow = [
        {
          protocol = "icmp"
        },
        {
          protocol = "tcp"
          ports    = ["667"]
        },
        {
          protocol = "udp"
          ports    = ["665-666"]
        }
      ]
    },
    {
      name        = "allow-health-check-ingress"
      direction   = "INGRESS"
      ranges      = ["130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23"]
      target_tags = ["vpc-connector", "health-check"]

      allow = [
        {
          protocol = "tcp"
        }
      ]
    },
    {
      name        = "allow-serverless-to-connector-ingress"
      direction   = "INGRESS"
      ranges      = ["107.178.230.64/26", "35.199.224.0/19"]
      target_tags = ["vpc-connector"]

      allow = [
        {
          protocol = "icmp"
        },
        {
          protocol = "tcp"
          ports    = ["667"]
        },
        {
          protocol = "udp"
          ports    = ["665-666"]
        }
      ]
    },
    {
      name        = "allow-iap-ingress"
      direction   = "INGRESS"
      ranges      = ["35.235.240.0/20"]
      target_tags = ["iap"]

      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "3389"]
        }
      ]
    },
    {
      name        = "allow-internal-ingress"
      direction   = "INGRESS"
      priority    = 65534
      ranges      = ["10.0.1.0/24"]
      source_tags = ["vpc-connector"]

      allow = [
        {
          protocol = "icmp"
        },
        {
          protocol = "tcp"
        },
        {
          protocol = "udp"
        }
      ]
    }
  ]

  connectors = [
    {
      name          = "vpc-connector"
      ip_cidr_range = "10.0.0.0/28"
      region        = "europe-west1"
    }
  ]
}
