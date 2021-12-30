variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "routers" {
  type        = any
  description = "Required. The list of routers."
}
