
#################################
##### Load Balancer - HTTPS #####
#################################

# URL Map
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "https" {
  name        = "tf-lb-${var.name}-https-url-map"
  description = "HTTPS Service Proxy - URL Map"
  # default_service = var.bucket_id
  # Send to specified host/path if using naked IP or unspecified domain
  default_url_redirect {
    https_redirect         = true
    host_redirect          = var.redirect_host
    path_redirect          = var.redirect_path
    redirect_response_code = "FOUND"
    strip_query            = true
  }

  host_rule {
    hosts        = var.hosts
    path_matcher = "bucket"
  }
  path_matcher {
    name            = "bucket"
    default_service = google_compute_backend_bucket.lb.id
  }
  # ... you can add more if desired
  # but take caution as it may add complication
  # and be better to have another load balancer
}

# Target
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy
# See Also: google_compute_region_target_https_proxy
resource "google_compute_target_https_proxy" "https" {
  name    = "tf-lb-${var.name}-https-target"
  url_map = google_compute_url_map.https.id
  # You can add multiple certificates
  ssl_certificates = [
    google_compute_managed_ssl_certificate.lb.id
  ]
  ssl_policy    = google_compute_ssl_policy.lb.id
  quic_override = "NONE"
}

# Forwarding Rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
# See Also: google_compute_forwarding_rule
resource "google_compute_global_forwarding_rule" "https" {
  name                  = "tf-lb-${var.name}-https-forwarding-rule"
  description           = "HTTPS Service Proxy - Forwarding Rule"
  ip_address            = google_compute_global_address.net_ipv4_a.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https.id
}
