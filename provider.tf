
# Before First Run
# tofu init
#
# After Upgrades or Additions
# tofu init -upgrade

terraform {
  required_version = ">= 1.7"
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

# Enables Needed GCP Services
module "gcp_services" {
  source     = "./modules/gcp_services"
  project_id = var.project_id
}
