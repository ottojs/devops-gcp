
variable "project_id" {
  description = "project_id"
}

variable "domain" {
  description = "FQDN - fully-qualified domain name to map to service"
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
}

variable "log_bucket_name" {
  description = "Name of logging bucket"
}

variable "page_index" {
  description = "page_index"
  default     = "index.html"
}

variable "page_404" {
  description = "page_404"
  default     = "404.html"
}

variable "cors_origins" {
  description = "Allowed CORS Origins"
  default     = []
}

variable "cors_methods" {
  description = "CORS allowed methods"
  default     = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]
}

variable "cors_headers" {
  description = "CORS response allowed headers"
  default     = ["*"]
}
