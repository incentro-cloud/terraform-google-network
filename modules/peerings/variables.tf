variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "peerings" {
  type        = any
  description = "Required. The list of peerings."
}
