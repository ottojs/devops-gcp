
# Cloud Run Service Agent
# https://cloud.google.com/iam/docs/understanding-roles#run.serviceAgent
# Warning: Do not grant service agent roles to any principals except service agents (Google Owned)
resource "google_project_iam_member" "gcp_internal_cloudrun_serviceagent" {
  project = var.project_id
  role    = "roles/run.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}
