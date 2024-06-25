
# Before First Run
# tofu init
#
# After Upgrades or Additions
# tofu init -upgrade

terraform {
  required_providers {
    local = {
      # https://registry.terraform.io/providers/hashicorp/local/latest/docs
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      # https://registry.terraform.io/providers/hashicorp/random/latest/docs
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "5.35.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}
