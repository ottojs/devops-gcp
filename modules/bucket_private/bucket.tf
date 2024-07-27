
##########################
##### Private Bucket #####
##########################

# https://console.cloud.google.com/storage/browser
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "private" {
  project                     = var.project_id
  name                        = var.name
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced" # "inherited"
  force_destroy               = !var.deletion_protection

  versioning {
    enabled = true
  }

  dynamic "logging" {
    for_each = var.log_bucket_name != "" ? ["logging"] : []
    content {
      log_bucket        = var.log_bucket_name
      log_object_prefix = "${var.log_bucket_name}/${var.name}"
    }
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
