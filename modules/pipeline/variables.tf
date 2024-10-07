
variable "project_id" {
  description = "project_id"
  type        = string
}

variable "project_number" {
  description = "project_number"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Name of pipeline"
}

variable "repo_provider" {
  description = "Name of repo host"
  type        = string
  default     = "github" # lowercase recommended
}

variable "repo_url_prefix" {
  description = "Prefix for provider"
  type        = string
  default     = "https://github.com"
}

variable "repo_owner" {
  description = "Owner of repo"
  type        = string
}

variable "repo_name" {
  description = "Name of repo"
  type        = string
}

variable "repo_branch" {
  description = "Name of branch to use when building"
  type        = string
  default     = "main"
}

variable "container_registry" {
  description = "Name of container registry"
}

variable "build_container" {
  description = "Name of container image to use when building"
  type        = string
  default     = "node:20.16.0-alpine3.20"
}

variable "machine_type" {
  description = "machine_type"
  type        = string
  default     = "E2_MEDIUM"
}

variable "logging" {
  description = "logging"
  type        = string
  default     = "CLOUD_LOGGING_ONLY"
}

variable "timeout" {
  description = "timeout"
  type        = string
  default     = "600s" # 10min
}

variable "steps" {
  description = "steps"
  type = list(object({
    id   = string
    name = string
    args = list(string)
    }
  ))
  default = []
}
