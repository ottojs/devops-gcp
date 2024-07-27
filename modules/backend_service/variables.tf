
variable "project_id" {
  description = "project_id"
}

variable "project_number" {
  description = "project_number"
}

variable "name" {
  description = "Name of backend service"
}

variable "region" {
  description = "region"
  default     = "us-central1"
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
}

variable "domain" {
  description = "FQDN - fully-qualified domain name to map to service"
}

variable "envvars_plain" {
  description = "Plain-text environment variables"
}

variable "envvars_secret" {
  description = "Secret environment variables"
}

variable "db_instance" {
  description = "Cloud SQL database instance to connect to"
}

variable "container_registry" {
  description = "Name of container registry to pull image from"
}

variable "container_image" {
  description = "Name of container image to use"
}

variable "cpu" {
  description = "Cloud Run CPU"
  default     = 1
}

variable "memory" {
  description = "Cloud Run Memory"
  default     = "512Mi"
}

variable "count_min" {
  description = "Cloud Run Autoscaling Minimum Instances"
  default     = 1
}

variable "count_max" {
  description = "Cloud Run Autoscaling Maximum Instances"
  default     = 10
}

variable "listen_port" {
  description = "What port the app container listens on"
  default     = 8080
}

locals {
  # DELETE, ABANDON, and sometimes DISABLE
  deletion_policy = var.deletion_protection == true ? "ABANDON" : "DELETE"
}
