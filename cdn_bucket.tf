
##########################
##### Website Bucket #####
##########################

# Notes on Caching
# https://cloud.google.com/cdn/docs/caching

# https://console.cloud.google.com/storage/browser
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "cdn" {
  project                     = var.project_id
  name                        = var.cdn_domain
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "inherited" # "enforced"
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

# Legacy ACL, Only usable on Fine-Grained not on Uniform Access
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control
# resource "google_storage_bucket_access_control" "cdn_public_acl_finegrained" {
#   bucket = google_storage_bucket.cdn.id
#   role   = "READER"
#   entity = "allUsers"
# }
#
# We use Uniform Access so we'll use this version instead
# https://cloud.google.com/storage/docs/uniform-bucket-level-access
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam
resource "google_storage_bucket_iam_member" "cdn_public_acl_uniform" {
  bucket = google_storage_bucket.cdn.id
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}
