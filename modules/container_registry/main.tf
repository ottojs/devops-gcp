
terraform {
  required_version = ">= 1.7"
  required_providers {
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "5.38.0"
    }
  }
}
