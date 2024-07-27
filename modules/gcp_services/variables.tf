
variable "project_id" {
  description = "project_id"
}

locals {
  # Prefer using the CLI?
  # gcloud services enable SERVICENAME
  #
  # These services are required to query/enable the other services
  gcp_essential = [
    # This one must be enabled with the CLI
    # "serviceusage.googleapis.com",
    #
    "cloudresourcemanager.googleapis.com",
  ]
  gcp_services = [
    # ===== Common Supporting Services =====
    "iam.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "certificatemanager.googleapis.com",
    # Cloud Run for Backend
    "run.googleapis.com",
    # Pipeline
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    # Optional, Used for Console Access to SQL
    "sqladmin.googleapis.com",
  ]
}
