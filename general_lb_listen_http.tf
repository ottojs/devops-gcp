#########################################
##### Load Balancer - HTTP to HTTPS #####
#########################################

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
# See Also google_compute_region_url_map
resource "google_compute_url_map" "lb_http" {
  name        = "tf-lb-http-url-map"
  description = "HTTP to HTTPS"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "lb_http" {
  name    = "tf-lb-http-target"
  url_map = google_compute_url_map.lb_http.id
}

resource "google_compute_global_forwarding_rule" "lb_http" {
  name                  = "tf-lb-http-forwarding-rule"
  ip_address            = google_compute_global_address.net_ipv4_a.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.lb_http.id
}
