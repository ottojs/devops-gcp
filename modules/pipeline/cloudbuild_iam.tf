
# Cloud Build
# Troubleshooting: You should see 2 services "Enabled" at the link below
# https://console.cloud.google.com/cloud-build/settings/service-account
#
# Details on Role Permissions
# https://cloud.google.com/iam/docs/understanding-roles

resource "google_project_iam_member" "cloudbuild_role_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_role_runadmin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_role_serviceaccountuser" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_role_meshconfig" {
  project = var.project_id
  role    = "roles/meshconfig.serviceAgent"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}

# Secret Manager Secret Accessor
# https://cloud.google.com/iam/docs/understanding-roles#secretmanager.secretAccessor
resource "google_project_iam_member" "cloudbuild_role_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}
