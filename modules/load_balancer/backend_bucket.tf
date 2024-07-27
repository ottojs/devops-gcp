
######################################################
##### Load Balancer - Backend Bucket for Website #####
######################################################

# Backend Bucket
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket
resource "google_compute_backend_bucket" "lb" {
  name        = "tf-lb-${var.name}-backend-bucket"
  description = "Directs traffic to bucket"
  bucket_name = var.bucket_name
  custom_response_headers = [
    "X-Frame-Options:DENY",
    "X-Content-Type-Options:nosniff",
    "Strict-Transport-Security:max-age=15768000",
    "Referrer-Policy:no-referrer",
    "Content-Security-Policy:${local.joined_csp}",
  ]
  enable_cdn       = var.cdn_enabled
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
