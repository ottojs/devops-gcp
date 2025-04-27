
terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "6.32.0"
    }
  }
}
