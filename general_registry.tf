
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "container_registry" {
  project       = var.project_id
  location      = var.region
  repository_id = var.container_registry
  description   = "Docker Registry"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"
}

# Artifact Registry Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.serviceAgent
resource "google_project_iam_member" "gcp_internal_artifact_registry_agent" {
  project = var.project_id
  role    = "roles/artifactregistry.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Artifact Registry Reader
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.reader
# Warning: Do not grant service agent roles to any principals except service agents (Google Owned)
resource "google_project_iam_member" "gcp_internal_artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}
