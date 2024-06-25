
#################################
##### Load Balancer - HTTPS #####
#################################

# URL Map
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "lb_https" {
  name        = "tf-lb-https-url-map"
  description = "HTTPS Service Proxy - URL Map"
  # default_service = google_compute_backend_bucket.cdn_backend_bucket.id
  # Send to Google if using naked IP or unspecified domain
  default_url_redirect {
    https_redirect         = true
    host_redirect          = "www.google.com"
    path_redirect          = "/"
    redirect_response_code = "FOUND"
    strip_query            = true
  }

  # TODO: Loop somehow
  host_rule {
    hosts        = ["cdn.${var.domain_root}"]
    path_matcher = "cdn"
  }
  path_matcher {
    name            = "cdn"
    default_service = google_compute_backend_bucket.cdn_backend_bucket.id
  }
  host_rule {
    hosts        = ["files.${var.domain_root}"]
    path_matcher = "files"
  }
  path_matcher {
    name            = "files"
    default_service = google_compute_backend_bucket.files_backend_bucket.id
  }
}

# Target
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy
# See Also: google_compute_region_target_https_proxy
resource "google_compute_target_https_proxy" "lb_https" {
  name    = "tf-lb-https-target"
  url_map = google_compute_url_map.lb_https.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.cdn.id,
    google_compute_managed_ssl_certificate.files.id
  ]
  ssl_policy    = google_compute_ssl_policy.project.id
  quic_override = "NONE"
}

# Forwarding Rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
# See Also: google_compute_forwarding_rule
resource "google_compute_global_forwarding_rule" "lb_https" {
  name                  = "tf-lb-https-forwarding-rule"
  description           = "HTTPS Service Proxy - Forwarding Rule"
  ip_address            = google_compute_global_address.net_ipv4_a.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.lb_https.id
}
