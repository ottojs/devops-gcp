
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
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    # Backend API
    "run.googleapis.com",
    # Optional, Used for Console
    "sqladmin.googleapis.com",
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "essential" {
  for_each = toset(local.gcp_essential)
  project  = var.project_id
  service  = each.key
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "general" {
  for_each = toset(local.gcp_services)
  project  = var.project_id
  service  = each.key
  timeouts {
    create = "10m"
    update = "10m"
  }
  disable_on_destroy = false
}
