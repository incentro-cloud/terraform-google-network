variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "peerings" {
  type        = any
  description = "The peerings."
  default     = []
}
