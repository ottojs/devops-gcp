
# Load Secret: DB Password
data "google_secret_manager_secret_version" "apidb_loader" {
  secret = "api-db-user-password"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "api_dbuser" {
  name     = "api-dbuser"
  instance = google_sql_database_instance.apidb_instance.name
  # ONLY FOR MySQL
  # host   = "example.com"
  password = data.google_secret_manager_secret_version.apidb_loader.secret_data
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
# DELETE or ABANDON (better)
resource "google_sql_database" "apidb" {
  name            = "postgresql-${local.api_name}"
  instance        = google_sql_database_instance.apidb_instance.name
  charset         = "UTF8"
  collation       = "en_US.UTF8"
  deletion_policy = local.deletion_policy
}

# https://cloud.google.com/sql/docs/postgres/connect-overview
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "apidb_instance" {
  name                = "postgresql-${local.api_name}-instance"
  region              = var.region
  database_version    = var.api_db_engine
  deletion_protection = var.deletion_protection
  settings {
    tier    = var.api_db_size
    edition = var.api_db_edition
    #user_labels = "test"
    activation_policy            = "ALWAYS"
    availability_type            = var.api_db_availability
    connector_enforcement        = "NOT_REQUIRED"
    deletion_protection_enabled  = var.deletion_protection
    enable_google_ml_integration = false
    disk_autoresize              = true
    disk_autoresize_limit        = 0
    # Gigabytes
    disk_size    = 10
    disk_type    = "PD_SSD"
    pricing_plan = "PER_USE"
    # https://cloud.google.com/sql/docs/postgres/flags#terraform
    database_flags {
      name  = "log_min_error_statement"
      value = "error"
    }
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = false
      location                       = var.region
      transaction_log_retention_days = 1
      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }
    ip_configuration {
      # This gives a public IP
      # Yes, this seems like a bad idea but GCP recommends it
      # We'l find an alternative way to access on VPC via VPN
      ipv4_enabled = true
      # private_network {}
      # TODO: Enable Mutual-Client TLS/SSL
      #require_ssl = true
      ssl_mode = "ENCRYPTED_ONLY" # SSL Only
      # ssl_mode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED" # Client Cert
    }
    maintenance_window {
      # Tuesday (1-7, starting Monday)
      day = 2
      # 0-23, this option requires "day" to be specified
      hour         = 2
      update_track = "stable"
    }
  }
}
