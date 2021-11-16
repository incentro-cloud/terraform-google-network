variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "create_network" {
  type        = bool
  description = "Optional. When set to 'true', a VPC network is created."
  default     = true
}

variable "name" {
  type        = string
  description = "Optional. The name of the VPC network."
  default     = ""
}

variable "routing_mode" {
  type        = string
  description = "Optional. The network routing mode."
  default     = "REGIONAL"
}

variable "description" {
  type        = string
  description = "Optional. The description of the VPC network."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "Optional. When set to 'true', the network is created in 'auto subnet mode'. When set to 'false', the network is created in 'custom subnet mode'."
  default     = false
}

variable "delete_default_routes_on_create" {
  type        = bool
  description = "Optional. If set, ensures that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."
  default     = false
}

variable "mtu" {
  type        = number
  description = "Optional. The network MTU. Must be a value between 1460 and 1500 inclusive. "
  default     = 1460
}

variable "shared_vpc" {
  type        = bool
  description = "Optional. Makes this project a shared VPC host project if 'true'."
  default     = false
}

variable "subnets" {
  type        = any
  description = "Optional. The list of subnets."
  default     = []
}

variable "routes" {
  type        = any
  description = "Optional. The list of routes."
  default     = []
}

variable "rules" {
  type        = any
  description = "Optional. The list of firewall rules."
  default     = []
}

variable "connectors" {
  type = any
  description = "Optional. The list of serverless VPC access connectors."
  default     = []
}

variable "peerings" {
  type        = any
  description = "Optional. The list of peerings."
  default     = []
}
