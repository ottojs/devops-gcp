
variable "project_id" {
  description = "project_id"
  type        = string
}

variable "project_number" {
  description = "project_number"
  type        = string
}

variable "name" {
  description = "Name of backend service"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-central1"
}

variable "deletion_protection" {
  description = "Boolean that determines if deletion protection is enabled"
  type        = bool
}

variable "domain" {
  description = "FQDN - fully-qualified domain name to map to service"
  type        = string
}

variable "envvars_plain" {
  description = "Plain-text environment variables"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "envvars_secret" {
  description = "Secret environment variables"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "db_instance" {
  description = "Cloud SQL database instance to connect to"
  type = object({
    connection_name = string
  })
}

variable "container_image" {
  description = "Name of container image to use"
  type        = string
}

variable "cpu" {
  description = "Cloud Run CPU"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Cloud Run Memory"
  type        = string
  default     = "512Mi"
}

variable "count_min" {
  description = "Cloud Run Autoscaling Minimum Instances"
  type        = number
  default     = 1
}

variable "count_max" {
  description = "Cloud Run Autoscaling Maximum Instances"
  type        = number
  default     = 10
}

variable "listen_port" {
  description = "What port the app container listens on"
  type        = number
  default     = 8080
}

locals {
  # DELETE, ABANDON, and sometimes DISABLE
  deletion_policy = var.deletion_protection == true ? "ABANDON" : "DELETE"
}
