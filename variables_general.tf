
##########################
##### IMPORTANT NOTE #####
##########################
# To make upgrades easier, you should only change these "variables_" files.
# If you need to make changes to the source files, please do so in a way
# that allows for customizations in these variable files unless the changes
# should be applied to all projects for reasons like security, performance, etc.

variable "credentials_file" {
  description = "Service Account key file path (usually .json)"
  default     = "project-key-file-a1b2c3d4e5f6.json"
}

# gcloud config get-value project
variable "project_id" {
  description = "Project ID"
  default     = "project-name"
}

# Get this value from CloudShell command
# gcloud projects list --filter="$(gcloud config get-value project)" --format="value(PROJECT_NUMBER)"
variable "project_number" {
  description = "Project Number"
  default     = "123456789012"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "ssl_policy_name" {
  description = "TLS SSL Policy Name"
  default     = "tf-ssl-policy-project"
}

variable "container_registry" {
  description = "Name of container registry"
  default     = "my-container-images"
}

variable "pipeline_build_container" {
  description = "Name of container image to use when building"
  default     = "node:20.14.0-alpine3.20"
}

variable "certificate_name" {
  description = "Name of SSL/TLS Certificate"
  default     = "cert-example-com"
}

variable "certificate_domains" {
  description = "Domains of SSL/TLS Certificate"
  default = [
    "api.example.com",
    "cdn.example.com",
    "files.example.com",
  ]
}
