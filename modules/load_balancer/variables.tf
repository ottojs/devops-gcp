
variable "project_id" {
  description = "project_id"
}

variable "name" {
  description = "Name of load balancer"
}

variable "hosts" {
  description = "Domains to point to service (generates certificates too)"
}

variable "bucket_id" {
  description = "Bucket ID to send traffic to"
}

variable "bucket_name" {
  description = "Bucket name to send traffic to"
}

variable "cdn_enabled" {
  description = "Boolean that determines if CDN is enabled"
}

variable "redirect_host" {
  description = "redirect_host"
  default     = "www.google.com"
}

variable "redirect_path" {
  description = "redirect_path"
  default     = "/"
}

# If you are running a SPA (single-page-app, React, Angular, Vue) you should probably edit the
# bucket settings to use "index.html" for both main page and error page instead of 404.html
variable "page_index" {
  description = "Filename to link to default page"
  default     = "index.html"
}
variable "page_404" {
  description = "Filename to link to not found page"
  default     = "404.html"
}

variable "content_security_policy" {
  description = "Allow bucket delete with files inside"
  default = [
    "default-src 'none'",
    "base-uri 'self'",
    "connect-src 'self' https://storage.googleapis.com https://fonts.gstatic.com",
    "font-src 'self' fonts.gstatic.com",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "frame-src 'none'",
    "img-src 'self' https: data:",
    "manifest-src 'self'",
    "media-src 'self'",
    "object-src 'none'",
    "require-trusted-types-for 'script'",
    "script-src 'self'",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
  ]
}

locals {
  joined_csp = join("; ", var.content_security_policy)
}
