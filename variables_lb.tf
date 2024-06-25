# If you are running a SPA (single-page-app, React, Angular, Vue) you should probably edit the
# bucket settings to use "index.html" for both main page and error page instead of 404.html
variable "lb_page_index" {
  description = "Filename to link to default page"
  default     = "index.html"
}
variable "lb_page_404" {
  description = "Filename to link to not found page"
  default     = "404.html"
}

variable "lb_cors_origins" {
  description = "Allowed CORS Origins"
  default = [
    "http://localhost:3000",
    "https://example.com",
    "https://www.example.com",
    "https://cdn.example.com",
  ]
}

variable "lb_cors_methods" {
  description = "CORS allowed methods"
  default     = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]
}

variable "lb_cors_headers" {
  description = "CORS response allowed headers"
  default     = ["*"]
}

variable "lb_content_security_policy" {
  description = "Allow bucket delete with files inside"
  default     = "default-src 'none'; base-uri 'self'; connect-src 'self' https://api.example.com https://storage.googleapis.com https://fonts.gstatic.com; font-src 'self' fonts.gstatic.com; form-action 'self'; frame-ancestors 'none'; frame-src 'none'; img-src 'self' https: data:; manifest-src 'self'; media-src 'self'; object-src 'none'; require-trusted-types-for 'script'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com"
}
