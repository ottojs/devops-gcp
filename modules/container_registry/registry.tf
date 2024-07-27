
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "container_registry" {
  project       = var.project_id
  location      = var.region
  repository_id = var.name
  description   = "Docker Registry"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"
}
