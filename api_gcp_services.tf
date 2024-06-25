
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "api-sqladmin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}
