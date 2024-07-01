###########################################################
##### Load Balancer - Backend Bucket for File Uploads #####
###########################################################

# Backend Bucket
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket
resource "google_compute_backend_bucket" "files" {
  name        = "tf-lb-backend-bucket-files"
  description = "Contains static resources for file uploads"
  bucket_name = google_storage_bucket.files.name
  enable_cdn  = false
  custom_response_headers = [
    "X-Frame-Options:DENY",
    "X-Content-Type-Options:nosniff",
    "Strict-Transport-Security:max-age=15768000",
    "Referrer-Policy:no-referrer",
    "Content-Security-Policy:${var.lb_content_security_policy}",
  ]
}
