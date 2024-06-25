
###############################
##### File Uploads Bucket #####
###############################

# Notes on Caching
# https://cloud.google.com/cdn/docs/caching

# https://console.cloud.google.com/storage/browser
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "files" {
  project                     = var.project_id
  name                        = var.files_domain
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced" # "inherited"
  force_destroy               = var.allow_bucket_delete

  website {
    main_page_suffix = var.lb_page_index
    not_found_page   = var.lb_page_404
  }
  cors {
    origin          = var.lb_cors_origins
    method          = var.lb_cors_methods
    response_header = var.lb_cors_headers
    max_age_seconds = 3600
  }
}
