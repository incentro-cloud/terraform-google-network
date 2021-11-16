variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "subnets" {
  type        = any
  description = "Required. The list of subnets."
}
