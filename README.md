# Network Module

![Cloud Build status](https://badger-tcppdqobjq-ew.a.run.app/build/status?project=examples-331911&id=c1c6a2cf-7fb8-4861-89da-8b29723d82b2 "Cloud Build status")

Module for creating a VPC network, subnets, routes, firewall rules, connectors, and peerings.

This module supports creating:

- VPC network
- Subnets
- Routes
- Firewall rules
- Serverless VCP access connectors (In progress)
- Peerings

## Usage

```hcl
module "network" {
  source = "github.com/IncentroNext/terraform-google-network"

  project_id                      = var.project_id
  name                            = "vpc-network"
  delete_default_routes_on_create = true

  subnets = [
    {
      name          = "connector"
      ip_cidr_range = "10.0.0.0/28"
      region        = "europe-west1"
      description   = "Subnet for serverless VPC access"
    },
    {
      name                     = "default"
      ip_cidr_range            = "10.0.1.0/24"
      region                   = "europe-west1"
      private_ip_google_access = true
      description              = "Subnet for default workloads"

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
      name                    = "allow-connector-to-serverless-egress"
      description             = null
      direction               = "EGRESS"
      priority                = null
      ranges                  = ["107.178.230.64/26", "35.199.224.0/19"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["vpc-connector"]
      target_service_accounts = null

      allow = [
        {
          protocol = "icmp"
          ports    = []
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

      deny = []
    },
    {
      name                    = "allow-health-check-ingress"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["vpc-connector", "health-check"]
      target_service_accounts = null

      allow = [
        {
          protocol = "tcp"
          ports    = []
        }
      ]

      deny = []
    },
    {
      name                    = "allow-serverless-to-connector-ingress"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["107.178.230.64/26", "35.199.224.0/19"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["vpc-connector"]
      target_service_accounts = null

      allow = [
        {
          protocol = "icmp"
          ports    = []
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

      deny = []
    },
    {
      name                    = "allow-iap-ingress"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["35.235.240.0/20"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["iap"]
      target_service_accounts = null

      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "3389"]
        }
      ]

      deny = []
    },
    {
      name                    = "allow-internal-ingress"
      description             = null
      direction               = "INGRESS"
      priority                = 65534
      ranges                  = ["10.0.1.0/24"]
      source_tags             = ["vpc-connector"]
      source_service_accounts = null
      target_tags             = []
      target_service_accounts = null

      allow = [
        {
          protocol = "icmp"
          ports    = []
        },
        {
          protocol = "tcp"
          ports    = []
        },
        {
          protocol = "udp"
          ports    = []
        }
      ]

      deny = []
    }
  ]
  
  connectors = []

  peerings = [
    {
      name         = "vpc-network-peering-vpc-network"
      network      = module.network.vpc[0].id
      peer_network = "projects/examples/global/networks/vpc-network"
    }
  ]
}
```