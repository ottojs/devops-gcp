
variable "project_id" {
  description = "project_id"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
  type        = bool
}

variable "log_bucket_name" {
  description = "log_bucket_name"
  type        = string
  default     = ""
}
