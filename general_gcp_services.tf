
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "general-artifactregistry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "general-compute" {
  project = var.project_id
  service = "compute.googleapis.com"
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}
