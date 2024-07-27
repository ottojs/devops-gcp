# You probably don't need this file after deployment
# You can probably delete it without issue (and then run "tofu apply" again)
# We use this to test the Storage Bucket CDN deployment is working with basic HTML files
# index.html - main page (index)
# 404.html - error page (not found)

# Storage Bucket Content
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object
resource "google_storage_bucket_object" "frontend_page_index" {
  name         = "index.html"
  content      = "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\"><meta name=\"description\" content=\"Description\"><title>Otto App - Index</title></head><body><h1>Otto App - Index</h1></body></html>"
  content_type = "text/html"
  bucket       = module.frontend_bucket.id
}
resource "google_storage_bucket_object" "frontend_page_404" {
  name         = "404.html"
  content      = "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\"><meta name=\"description\" content=\"Not Found\"><title>Otto App - 404 Not Found</title></head><body><h1>Otto App - 404 Not Found</h1></body></html>"
  content_type = "text/html"
  bucket       = module.frontend_bucket.id
}
