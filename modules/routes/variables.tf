variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "routes" {
  type        = any
  description = "The routes."
  default     = []
}
