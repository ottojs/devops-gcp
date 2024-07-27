
variable "project_id" {
  description = "project_id"
}

variable "project_number" {
  description = "project_number"
}

variable "region" {
  description = "region"
  default     = "us-central1"
}

variable "name" {
  description = "Name of pipeline"
}

variable "repo_provider" {
  description = "Name of repo host"
  default     = "github" # lowercase recommended
}

variable "repo_url_prefix" {
  description = "Prefix for provider"
  default     = "https://github.com"
}

variable "repo_owner" {
  description = "Owner of repo"
}

variable "repo_name" {
  description = "Name of repo"
}

variable "repo_branch" {
  description = "Name of branch to use when building"
  default     = "main"
}

variable "container_registry" {
  description = "Name of container registry"
}

variable "build_container" {
  description = "Name of container image to use when building"
  default     = "node:20.16.0-alpine3.20"
}

variable "machine_type" {
  description = "machine_type"
  default     = "E2_MEDIUM"
}

variable "logging" {
  description = "logging"
  default     = "CLOUD_LOGGING_ONLY"
}

variable "timeout" {
  description = "timeout"
  default     = "600s" # 10min
}

variable "steps" {
  description = "steps"
  default     = []
}
