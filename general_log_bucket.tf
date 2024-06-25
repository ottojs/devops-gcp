
#######################
##### Logs Bucket #####
#######################

# https://console.cloud.google.com/storage/browser
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "logs" {
  project                     = var.project_id
  name                        = "gcp-logs-${var.project_id}"
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced" # "inherited"
  force_destroy               = !var.deletion_protection
  versioning {
    enabled = true
  }
}
