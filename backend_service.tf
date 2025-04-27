
# You can also use the domain for the name
# replace(var.domain_api, ".", "-")
#
# We use locals for this so we can re-use this in envvars
locals {
  backend_name = "api"
}

module "backend_service" {
  source              = "./modules/backend_service"
  project_id          = var.project_id
  project_number      = var.project_number
  region              = var.region
  name                = local.backend_name
  deletion_protection = var.deletion_protection
  domain              = var.domain_api
  container_image     = local.pipeline_backend_repo_name
  envvars_plain       = local.envvars_plain
  envvars_secret      = local.envvars_secret
  db_instance         = module.backend_database.instance
}

locals {
  # Environment Variables (Plain-Text)
  envvars_plain = [
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
      value = var.domain_api
    },
    {
      name  = "API_URI"
      value = "https://${var.domain_api}"
    },
    {
      name  = "APP_DOMAIN"
      value = var.domain_app
    },
    {
      name  = "APP_URI"
      value = "https://${var.domain_app}"
    },
    {
      name  = "SQL_URI"
      value = "GCP"
    },
    {
      name  = "SQL_USERNAME"
      value = module.backend_database.user_name
    },
    {
      name  = "SQL_DATABASE"
      value = module.backend_database.db_name
    },
    {
      name  = "SQL_CONNNAME"
      value = module.backend_database.connection_name
    },
    {
      name = "CORS_ALLOWED_ORIGINS"
      value = join(",", [
        "https://${var.domain_root}",
        "https://${var.domain_app}",
      ])
    },
    {
      name  = "GCP_BUCKET_NAME"
      value = var.domain_app
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
  envvars_secret = [
    {
      # Generated
      name  = "SQL_PASSWORD"
      value = module.backend_database.user_password_secret_id
    },
    {
      # Generated
      name  = "COOKIE_SECRET"
      value = "tf-${local.backend_name}-cookie-secret"
    },
    {
      # Generated
      name  = "CSRF_SECRET"
      value = "tf-${local.backend_name}-csrf-secret"
    },
    {
      # Manual
      name  = "EMAIL_MAILGUN_API_KEY"
      value = "${local.backend_name}-mailgun-secret"
    },
    {
      # Manual
      name  = "STRIPE_SECRET_KEY"
      value = "${local.backend_name}-stripe-secret"
    },
  ]
}
