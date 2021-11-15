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
# VPC NETWORKS, SUBNETS, AND PEERINGS
# ---------------------------------------------------------------------------------------------------------------------

module "network_01" {
  source = "../../"

  project_id = var.project_id
  name       = "vpc-network-01"

  subnets = [
    {
      name          = "default-europe-west1"
      ip_cidr_range = "10.0.1.0/24"
      region        = "europe-west1"
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

module "network_03" {
  source = "../../"

  project_id = var.project_id
  name       = "vpc-network-03"

  subnets = [
    {
      name          = "default"
      ip_cidr_range = "10.2.1.0/24"
      region        = "europe-west4"
    }
  ]
}

module "network_01_peerings" {
  source = "../../"

  project_id     = var.project_id
  create_network = false

  peerings = [
    {
      name         = "vpc-network-01-peering-vpc-network-02"
      network      = module.network_01.vpc[0].id
      peer_network = module.network_02.vpc[0].id
    },
    {
      name         = "vpc-network-01-peering-vpc-network-03"
      network      = module.network_01.vpc[0].id
      peer_network = module.network_03.vpc[0].id
    }
  ]
}

module "network_02_peerings" {
  source = "../../"

  project_id     = var.project_id
  create_network = false

  peerings = [
    {
      name         = "vpc-network-02-peering-vpc-network-01"
      network      = module.network_02.vpc[0].id
      peer_network = module.network_01.vpc[0].id
    }
  ]
}

module "network_03_peerings" {
  source = "../../"

  project_id     = var.project_id
  create_network = false

  peerings = [
    {
      name         = "vpc-network-03-peering-vpc-network-01"
      network      = module.network_03.vpc[0].id
      peer_network = module.network_01.vpc[0].id
    }
  ]
}
