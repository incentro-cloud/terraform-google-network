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
# VPC NETWORK, SUBNETS, AND PEERINGS
# ---------------------------------------------------------------------------------------------------------------------

module "network_01" {
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
      name         = "vpc-network-01-peer-vpc-network-02"
      peer_network = module.network_02.vpc_id
    }
  ]
}

module "network_02" {
  source = "../../"

  project_id = var.project_id
  name       = "vpc-network-02"

  subnets = [
    {
      name          = "default"
      ip_cidr_range = "10.1.1.0/24"
      region        = "europe-west3"
    }
  ]
}

module "network_02_peerings" {
  source = "../../"

  project_id = var.project_id
  create_vpc = false

  peerings = [
    {
      name         = "vpc-network-02-peer-vpc-network-01"
      network      = module.network_02.vpc_id
      peer_network = module.network_01.vpc_id
    }
  ]
}
