variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "create_network" {
  type = bool
  description = "Optional. When set to 'true', a VPC network is created."
}

variable "name" {
  type        = string
  description = "Optional. The name of the VPC network."
}

variable "routing_mode" {
  type        = string
  description = "Optional. The network routing mode."
}

variable "description" {
  type        = string
  description = "Optional. The description of the VPC network."
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "Optional. When set to true, the network is created in 'auto subnet mode'. When set to false, the network is created in 'custom subnet mode'."
}

variable "delete_default_routes_on_create" {
  type        = bool
  description = "Optional. If set, ensures that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."
}

variable "mtu" {
  type        = number
  description = "Optional. The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
}

variable "shared_vpc" {
  type        = bool
  description = "Optional. Makes this project a shared VPC host project if 'true'."
}
