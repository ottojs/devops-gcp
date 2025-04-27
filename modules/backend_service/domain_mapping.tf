
# Domain
# TODO: Move to load balancer because of configuration flexibility
#       Example: TLS configuration
# NOTE: You could also pipe this through the Load Balancer
#       We do not do that here for purposes of illustration
#       The downside to this approach is if you need to replace
#       this service, it is possible the certificate will be replaced too
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_domain_mapping
resource "google_cloud_run_domain_mapping" "backend" {
  name     = var.domain
  project  = var.project_id
  location = var.region
  metadata {
    namespace = var.project_id
  }
  spec {
    force_override   = false
    route_name       = google_cloud_run_v2_service.backend.name
    certificate_mode = "AUTOMATIC"
  }
  depends_on = [
    google_cloud_run_v2_service.backend
  ]
}
