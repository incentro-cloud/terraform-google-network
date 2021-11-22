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
# VPC NETWORKS, SUBNETS, AND PEERING
# ---------------------------------------------------------------------------------------------------------------------

module "network" {
  source = "../../"

  project_id = var.project_id
  name       = "vpc-network"

  subnets = [
    {
      name          = "default"
      ip_cidr_range = "10.0.1.0/24"
      region        = "europe-west1"
    }
  ]

  peerings = [
    {
      name         = "vpc-network-01-peer-vpc-network-peer"
      peer_network = module.network_peer.vpc[0].id
    }
  ]
}

module "network_peer" {
  source = "../../"

  project_id = var.project_id
  name       = "vpc-network-peer"

  subnets = [
    {
      name          = "default"
      ip_cidr_range = "10.1.1.0/24"
      region        = "europe-west3"
    }
  ]
}
