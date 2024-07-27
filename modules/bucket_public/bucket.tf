
###################################
##### Public Bucket - Website #####
###################################

# Notes on Caching
# https://cloud.google.com/cdn/docs/caching

# https://console.cloud.google.com/storage/browser
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "public" {
  project                     = var.project_id
  name                        = var.domain # Usually a domain (FQDN)
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "inherited" # "enforced"
  force_destroy               = !var.deletion_protection

  versioning {
    enabled = true
  }

  logging {
    log_bucket        = var.log_bucket_name
    log_object_prefix = "${var.log_bucket_name}/${var.domain}"
  }

  website {
    main_page_suffix = var.page_index
    not_found_page   = var.page_404
  }

  cors {
    origin          = var.cors_origins
    method          = var.cors_methods
    response_header = var.cors_headers
    max_age_seconds = 3600
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      days_since_noncurrent_time = 3
      no_age                     = true
    }
  }
}

# Legacy ACL, Only usable on Fine-Grained not on Uniform Access
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control
# resource "google_storage_bucket_access_control" "public_acl_finegrained" {
#   bucket = google_storage_bucket.public.id
#   role   = "READER"
#   entity = "allUsers"
# }
#
# We use Uniform Access so we'll use this version instead
# https://cloud.google.com/storage/docs/uniform-bucket-level-access
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam
resource "google_storage_bucket_iam_member" "public_acl_uniform" {
  bucket = google_storage_bucket.public.id
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}
