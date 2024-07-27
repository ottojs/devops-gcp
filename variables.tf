
##########################
##### IMPORTANT NOTE #####
##########################
# If you need to make changes to the source module files, please do so in a way
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

variable "domain_root" {
  description = "Root domain"
  default     = "example.com"
}

variable "domain_api" {
  description = "API domain"
  default     = "api.example.com"
}

variable "domain_app" {
  description = "App domain"
  default     = "app.example.com"
}

variable "build_container" {
  description = "Name of container image to use when building"
  default     = "node:20.16.0-alpine3.20"
}

# WARNING: If you are deploying this for real applications, set this to true
#          Otherwise, you are at risk of deleting all of your valuable data
variable "deletion_protection" {
  description = "Enable deletion protection on all resources?"
  default     = true
}
