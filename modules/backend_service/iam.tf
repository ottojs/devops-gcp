
# Service Account
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "backend" {
  account_id   = "tf-${var.name}-srvacc"
  display_name = "Service Account"
}

# Cloud Run Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#run.serviceAgent
# Warning: Do not grant service agent roles to any principals except service agents (Google Owned)
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "gcp_internal_cloudrun_serviceagent" {
  project = var.project_id
  role    = "roles/run.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Artifact Registry Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.serviceAgent
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.serviceAgent"
  member  = google_service_account.backend.member
}

# Cloud SQL Client
# https://cloud.google.com/iam/docs/understanding-roles#cloudsql.client
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = google_service_account.backend.member
}

# Secret Manager Secret Accessor
# https://cloud.google.com/iam/docs/understanding-roles#secretmanager.secretAccessor
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = google_service_account.backend.member
}

# Required for Signed Upload URLs to Storage Bucket
# Granular Permission: iam.serviceAccounts.signBlob (maybe others)
# https://cloud.google.com/iam/docs/understanding-roles#iam.serviceAccountTokenCreator
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = google_service_account.backend.member
}

# Required for Signed Upload URLs to Storage Bucket
# https://cloud.google.com/iam/docs/understanding-roles#storage.objectCreator
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member-1
resource "google_project_iam_member" "storage_object_creator" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = google_service_account.backend.member
}

# Allow Public Access
# https://cloud.google.com/run/docs/authenticating/public#terraform
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam#google_cloud_run_service_iam_member-1
resource "google_cloud_run_service_iam_member" "backend" {
  location = google_cloud_run_v2_service.backend.location
  service  = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
