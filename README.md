# Network module

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
  source = "incentro-cloud/terraform-google-network"
  version = "~> 0.1"

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

## Arguments

Most arguments map to the official supported arguments. Links to the official documentation are included for completeness.

[Click here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network "google_compute_network") for the official **google_compute_network** documentation.

| Name | Type | Default | Description |
|---|---|---|---|
| `project_id` | string |  | Required. The project identifier. |
| `create_network` | bool | true | Optional. When set to 'true', a VPC network is created. |
| `name` | string | null | Required when `create_network` set to 'true'. The name of the VPC network. |
| `routing_mode` | string | REGIONAL | Optional. The network routing mode. |
| `description` | string | null | Optional. The description of the VPC network. |
| `auto_create_subnetworks` | bool | false | Optional. When set to 'true', the network is created in 'auto subnet mode'. When set to 'false', the network is created in 'custom subnet mode'. |
| `delete_default_routes_on_create` | bool | false | Optional. If set, ensures that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted. |
| `mtu` | number | 1460 | Optional. The network MTU. Must be a value between 1460 and 1500 inclusive. |
| `shared_vpc` | bool | false | Optional. Makes this project a shared VPC host project if 'true'. |
| `subnets` | any | [] | Optional. The list of subnets. |
| `routes` | any | [] | Optional. The list of routes. |
| `rules` | any | [] | Optional. The list of firewall rules. |
| `peerings` | any | [] | Optional. The list of peerings. |

### Subnets

[Click here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork "google_compute_subnetwork") for the official **google_compute_subnetwork** documentation.

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string |  | Required. The name of the subnet. |
| `network` | string | module.vpc.vpc[0].name | Optional. The network this subnet belongs to. |
| `ip_cidr_range` | string | | Required. The range of internal addresses for the subnet. |
| `region` | string | | Required. The region of the subnet.  |
| `description` | string | null | Optional. The description of the subnet. |
| `purpose` | string | "PRIVATE" | Optional. The purpose of the subnet. |
| `role` | string | null | Optional. The role of subnet. |
| `private_ip_google_access` | bool | false | Optional. When set to 'true', virtual machine instances in this subnet without external IP addresses can access Google APIs and services. |
| `log_config` | any | null | Optional. The logging options for the subnet flow logs. |
| `secondary_ip_ranges` | any | [] | Optional. The list of secondary IP ranges for virtual machine instances contained in this subnet. |

### Routes

[Click here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route "google_compute_route") for the official **google_compute_route** documentation.

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string |  | Required. The name of the route. |
| `network` | string | module.vpc.vpc[0].name | Optional. The network this route belongs to. |
| `description` | string | null | Optional. The description of the subnet. |
| `tags` | any | null | Optional. The instance tags to which this route applies. |
| `dest_range` | string |  | Required. The destination range of outgoing packets that this route applies to. |
| `next_hop_gateway` | string | null | Optional. The URL to a gateway that should handle matching packets. |
| `next_hop_ip` | string | null | Optional. The IP address of an instance that should handle matching packets. |
| `next_hop_instance` | string | null | Optional. The URL to an instance that should handle matching packets. |
| `next_hop_instance_zone` | string | null | Optional when `next_hop_instance` is specified. The zone of the instance specified in `next_hop_instance`. |
| `next_hop_vpn_tunnel` | string | null | Optional. The URL to a VPN tunnel that should handle matching packets. |
| `next_hop_ilb` | string | null | Optional. The IP address or URL to a forwarding rule that should handle matching packets. |
| `priority` | number | 1000 | Optional. The priority of this route. |

### Firewall rules

[Click here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall "google_compute_firewall") for the official **google_compute_firewall** documentation.

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string |  | Required. The name of the firewall rule. |
| `network` | string |  module.vpc.vpc[0].name | Optional. The name or self_link of the network to attach this firewall to. |
| `direction` | string |  | Required. The direction of traffic to which this firewall applies. |
| `priority` | number | 1000 | Optional. The priority for this rule. This is an integer between 0 and 65535, both inclusive. When not specified, the value assumed is 1000. |
| `description` | string | null | Optional. The description of the firewall rule. |
| `ranges` | any | null | Optional. If ranges are specified, the firewall will apply only to traffic that has IP address in these ranges. These ranges must be expressed in CIDR format. |
| `source_tags` | any | null | Optional. If source tags are specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address. |
| `source_service_accounts` | any | null | Optional. If source service accounts are specified, the firewall will apply only to traffic originating from an instance with a service account in this list. Source service accounts cannot be used to control traffic to an instance's external IP address because service accounts are associated with an instance, not an IP address. |
| `target_tags` | any | null | Optional. The instance tags indicating sets of instances located in the network that may make network connections as specified in allowed. |
| `target_service_accounts` | any | null | Optional. The service accounts indicating sets of instances located in the network that may make network connections as specified in allowed. |
| `allow` | any | [] | Optional. The list of allow rules specified by this firewall. Each rule specifies a protocol and port-range tuple that describes a permitted connection. |
| `deny` | any | [] | Optional. The list of deny rules specified by this firewall. Each rule specifies a protocol and port-range tuple that describes a denied connection. |
| `log_config` | any | null | Optional. The logging options. If defined, logging is enabled, and logs will be exported to Cloud Logging. |

## Outputs

| Name | Description |
|---|---|
| `vpc` | The VPC network. |
| `vpc_name` | The name of the VPC network. |
| `subnets` | The subnets. |
| `subnets_names` | The names of the subnets. |
| `routes` | The routes. |
| `routes_names` | The names of the routes. |
| `rules` | The rules. |
| `rules_names` | The names of the rules. |
| `peerings` | The peerings. |
| `peerings_names` | The names of the peerings. |
