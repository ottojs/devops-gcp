
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "essential" {
  for_each = toset(local.gcp_essential)
  project  = var.project_id
  service  = each.key
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "general" {
  for_each = toset(local.gcp_services)
  project  = var.project_id
  service  = each.key
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
  depends_on         = [google_project_service.essential]
}
