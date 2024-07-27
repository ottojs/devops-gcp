
module "frontend_bucket" {
  source              = "./modules/bucket_public"
  project_id          = var.project_id
  domain              = var.domain_app
  page_404            = "index.html"
  deletion_protection = var.deletion_protection
  log_bucket_name     = module.log_bucket.name
  cors_origins = [
    "https://${var.domain_app}",
  ]
  cors_methods = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]
  cors_headers = ["*"]
}
