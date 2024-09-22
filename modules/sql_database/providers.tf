
terraform {
  required_version = ">= 1.8"
  required_providers {
    random = {
      # https://registry.terraform.io/providers/hashicorp/random/latest/docs
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "6.3.0"
    }
  }
}
