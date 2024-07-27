
variable "project_id" {
  description = "project_id"
}

variable "name" {
  description = "name"
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
}

variable "log_bucket_name" {
  description = "log_bucket_name"
  default     = ""
}
