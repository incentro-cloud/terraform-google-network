variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "connectors" {
  type = any
  description = "Required. The list of connectors."
}
