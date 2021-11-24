# Network peerings

This example illustrates how to create two VPC networks, subnets, and a peerings.

It will do the following:

- Create two VPC networks and subnets.
- Create the peerings to peer the VPC networks.

## Example usage

This is an example of the usage of the module.

```hcl
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
      peer_network = module.network_02.vpc[0].id
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
      network      = module.network_02.vpc[0].id
      peer_network = module.network_01.vpc[0].id
    }
  ]
}
```
