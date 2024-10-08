
variable "project_id" {
  description = "project_id"
  type        = string
}

variable "domain" {
  description = "FQDN - fully-qualified domain name to map to service"
  type        = string
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
  type        = bool
}

variable "log_bucket_name" {
  description = "Name of logging bucket"
  type        = string
}

# If you are running a SPA (single-page-app, React, Angular, Vue) you should probably edit the
# bucket settings to use "index.html" for both main page and error page instead of 404.html
variable "page_index" {
  description = "Filename to link to default page"
  type        = string
  default     = "index.html"
}
variable "page_404" {
  description = "Filename to link to not found page"
  type        = string
  default     = "404.html"
}

variable "cors_origins" {
  description = "Allowed CORS Origins"
  type        = list(string)
  default     = []
}

variable "cors_methods" {
  description = "CORS allowed methods"
  type        = list(string)
  default     = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]
}

variable "cors_headers" {
  description = "CORS response allowed headers"
  type        = list(string)
  default     = ["*"]
}
