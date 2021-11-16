variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "rules" {
  type        = any
  description = "Required. The list of firewall rules."
}
