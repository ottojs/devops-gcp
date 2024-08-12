
terraform {
  required_providers {
    random = {
      # https://registry.terraform.io/providers/hashicorp/random/latest/docs
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs
      source  = "hashicorp/google"
      version = "5.40.0"
    }
  }
}
