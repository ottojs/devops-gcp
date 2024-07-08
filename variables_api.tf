
##########################
##### IMPORTANT NOTE #####
##########################
# To make upgrades easier, you should only change these "variables_" files.
# If you need to make changes to the source files, please do so in a way
# that allows for customizations in these variable files unless the changes
# should be applied to all projects for reasons like security, performance, etc.

locals {
  # Environment Variables (Plain-Text)
  api_envvars_plain = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "DEBUG"
      value = "app:*"
    },
    {
      name  = "API_DOMAIN"
      value = "api.example.com"
    },
    {
      name  = "API_URI"
      value = "https://api.example.com"
    },
    {
      name  = "APP_DOMAIN"
      value = "cdn.example.com"
    },
    {
      name  = "APP_URI"
      value = "https://cdn.example.com"
    },
    {
      name  = "SQL_URI"
      value = "GCP"
    },
    {
      name  = "SQL_USERNAME"
      value = google_sql_user.api_dbuser.name
    },
    {
      name  = "SQL_DATABASE"
      value = google_sql_database.apidb.name
    },
    {
      name  = "SQL_CONNNAME"
      value = google_sql_database_instance.apidb_instance.connection_name
    },
    {
      name  = "CORS_ALLOWED_ORIGINS"
      value = "https://example.com,https://www.example.com,https://cdn.example.com"
    },
    {
      name  = "GCP_BUCKET_NAME"
      value = "cdn.example.com"
    },
    {
      name  = "EMAIL_PROVIDER"
      value = "mailgun"
    },
    {
      name = "EMAIL_MAILGUN_CONFIG"
      value = jsonencode({
        "api_endpoint" : "https://api.mailgun.net",
        "domain" : "mailgun.example.com",
        "from_name" : "Mailgun App",
        "from_email" : "help@example.com",
        "reply_to" : "help@example.com",
      })
    },
    {
      name  = "STRIPE_ONETIME_PRICE_ID"
      value = "price_RANDOMID"
    },
    {
      name  = "STRIPE_SUBSCRIPTION_PRICE_ID"
      value = "price_RANDOMID"
    },
    {
      name  = "REGISTER_CODE"
      value = "1234"
    },
  ]
  # Environment Variables (Secrets)
  api_envvars_secret = [
    {
      name  = "SQL_PASSWORD"
      value = google_secret_manager_secret.apidb.secret_id
    },
    {
      name  = "COOKIE_SECRET"
      value = "api-cookie-secret"
    },
    {
      name  = "CSRF_SECRET"
      value = "api-csrf-secret"
    },
    {
      name  = "EMAIL_MAILGUN_API_KEY"
      value = "api-mailgun-secret"
    },
    {
      name  = "STRIPE_SECRET_KEY"
      value = "api-stripe-secret"
    },
  ]
}

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
