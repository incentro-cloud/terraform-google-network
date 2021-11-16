variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "create_network" {
  type = bool
  description = "When set to 'true', a VPC network is created."
  default = true
}

variable "name" {
  type        = string
  description = "The name of the VPC network."
  default     = ""
}

variable "routing_mode" {
  type        = string
  description = "The network routing mode."
  default     = "REGIONAL"
}

variable "description" {
  type        = string
  description = "Description of the VPC network."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to 'true', the network is created in 'auto subnet mode'. When set to 'false', the network is created in 'custom subnet mode'."
  default     = false
}

variable "delete_default_routes_on_create" {
  type        = bool
  description = "If set, ensures that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."
  default     = false
}

variable "mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
  default     = 0
}

variable "shared_vpc" {
  type        = bool
  description = "Makes this project a shared VPC host project if 'true'."
  default     = false
}

variable "subnets" {
  type        = any
  description = "The subnets."
  default     = []
}

variable "routes" {
  type        = any
  description = "The routes."
  default     = []
}

variable "rules" {
  type        = any
  description = "The firewall rules."
  default     = []
}

variable "peerings" {
  type        = any
  description = "The peerings."
  default     = []
}
