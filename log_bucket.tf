
module "log_bucket" {
  source              = "./modules/bucket_private"
  project_id          = var.project_id
  name                = "logging-${var.project_id}"
  deletion_protection = var.deletion_protection
}
