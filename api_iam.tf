
# API Service Account
resource "google_service_account" "api" {
  account_id   = "service-account-api"
  display_name = "Service Account API"
}

# Cloud Run Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#run.serviceAgent
# Warning: Do not grant service agent roles to any principals except service agents (Google Owned)
resource "google_project_iam_member" "gcp_internal_cloudrun_serviceagent" {
  project = var.project_id
  role    = "roles/run.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Artifact Registry Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.serviceAgent
resource "google_project_iam_member" "api_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.serviceAgent"
  member  = google_service_account.api.member
}

# Cloud SQL Client
# https://cloud.google.com/iam/docs/understanding-roles#cloudsql.client
resource "google_project_iam_member" "api_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = google_service_account.api.member
}

# Secret Manager Secret Accessor
# https://cloud.google.com/iam/docs/understanding-roles#secretmanager.secretAccessor
resource "google_project_iam_member" "api_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = google_service_account.api.member
}

# Required for Signed Upload URLs to Storage Bucket
# Granular Permission: iam.serviceAccounts.signBlob (maybe others)
# https://cloud.google.com/iam/docs/understanding-roles#iam.serviceAccountTokenCreator
resource "google_project_iam_member" "api_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = google_service_account.api.member
}

# Required for Signed Upload URLs to Storage Bucket
# https://cloud.google.com/iam/docs/understanding-roles#storage.objectCreator
resource "google_project_iam_member" "api_storage_object_creator" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = google_service_account.api.member
}
