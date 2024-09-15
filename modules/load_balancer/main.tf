
terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "6.2.0"
    }
  }
}
