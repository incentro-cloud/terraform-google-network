variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "rules" {
  type        = any
  description = "The firewall rules."
  default     = []
}
