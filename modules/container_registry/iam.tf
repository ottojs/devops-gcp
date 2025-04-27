
# Artifact Registry Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.serviceAgent
#
# https://registry.terraform.io/providers/hashicorp/google/6.32.0/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "gcp_internal_artifact_registry_agent" {
  project = var.project_id
  role    = "roles/artifactregistry.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Artifact Registry Reader
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.reader
# Warning: Do not grant service agent roles to any principals except service agents (Google Owned)
#
# https://registry.terraform.io/providers/hashicorp/google/6.32.0/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "gcp_internal_artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}
