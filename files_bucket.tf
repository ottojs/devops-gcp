
# Used for file uploads (in the future)
module "files_bucket" {
  source              = "./modules/bucket_private"
  project_id          = var.project_id
  name                = "files.${var.domain_root}"
  deletion_protection = var.deletion_protection
  log_bucket_name     = module.log_bucket.name
}
