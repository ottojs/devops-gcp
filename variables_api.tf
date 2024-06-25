
##########################
##### IMPORTANT NOTE #####
##########################
# To make upgrades easier, you should only change these "variables_" files.
# If you need to make changes to the source files, please do so in a way
# that allows for customizations in these variable files unless the changes
# should be applied to all projects for reasons like security, performance, etc.

variable "api_domain" {
  description = "FQDN to host"
  default     = "api.example.com"
}

variable "api_repo_owner" {
  description = "Owner of repo"
  default     = "ryanlelek"
}

variable "api_repo_name" {
  description = "Name of repo"
  default     = "boilerplate-backend-node"
}

variable "api_cpu" {
  description = "Cloud Run CPU"
  default     = 1
}

variable "api_memory" {
  description = "Cloud Run Memory"
  default     = "512Mi"
}

variable "api_count_min" {
  description = "Cloud Run Autoscaling Minimum Instances"
  default     = 1
}

variable "api_count_max" {
  description = "Cloud Run Autoscaling Maximum Instances"
  default     = 10
}

variable "api_envvars_plain" {
  description = "Environment Variables (Plain-Text)"
  default = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "CORS_ALLOWED_ORIGINS"
      value = "https://example.com,https://www.example.com,https://cdn.example.com"
    },
    {
      name  = "GCP_BUCKET_NAME"
      value = "cdn.example.com"
    },
  ]
}
variable "api_envvars_secret" {
  description = "Environment Variables (Secrets)"
  default = [
    {
      name  = "COOKIE_SECRET"
      value = "api-cookie-secret"
    },
    {
      name  = "CSRF_SECRET"
      value = "api-csrf-secret"
    },
  ]
}

# https://cloud.google.com/sql/docs/postgres/editions-intro
# ENTERPRISE or ENTERPRISE_PLUS (better)
variable "api_db_edition" {
  description = "Database Edition"
  default     = "ENTERPRISE"
}

# ZONAL or REGIONAL (better)
variable "api_db_availability" {
  description = "Database Availability"
  default     = "REGIONAL"
}

# https://cloud.google.com/sql/pricing
# https://cloud.google.com/sdk/gcloud/reference/sql/tiers/list
# gcloud sql tiers list
variable "api_db_size" {
  description = "Database instance size"
  default     = "db-f1-micro"
}

# https://cloud.google.com/sql/docs/postgres/db-versions
variable "api_db_engine" {
  description = "Database Engine"
  default     = "POSTGRES_16"
}
