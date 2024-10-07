
variable "project_id" {
  description = "project_id"
  type        = string
}

variable "project_number" {
  description = "project_number"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Name of the registry, needs to be unique"
  type        = string
}
