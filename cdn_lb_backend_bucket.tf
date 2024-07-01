###############################################################
##### Load Balancer - Backend Bucket for CDN Static Files #####
###############################################################

# Backend Bucket
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket
resource "google_compute_backend_bucket" "cdn" {
  name        = "tf-lb-backend-bucket-cdn"
  description = "Contains static resources for file uploads"
  bucket_name = google_storage_bucket.cdn.name
  custom_response_headers = [
    "X-Frame-Options:DENY",
    "X-Content-Type-Options:nosniff",
    "Strict-Transport-Security:max-age=15768000",
    "Referrer-Policy:no-referrer",
    "Content-Security-Policy:${var.lb_content_security_policy}",
  ]
  # CDN Parameters - TODO: Variables
  enable_cdn       = true
  compression_mode = "AUTOMATIC"
  cdn_policy {
    cache_mode         = "CACHE_ALL_STATIC"
    default_ttl        = 86400
    client_ttl         = 86400
    max_ttl            = 172800
    negative_caching   = false
    serve_while_stale  = 86400
    request_coalescing = true
  }
}
