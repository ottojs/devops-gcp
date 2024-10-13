
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "dbuser" {
  name     = "tf-${var.name}-dbuser"
  instance = google_sql_database_instance.db_instance.name
  # ONLY FOR MySQL
  # host   = "example.com"
  #password = data.google_secret_manager_secret_version.db_loader.secret_data
  password = random_password.db.result
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
resource "google_sql_database" "db" {
  name            = "tf-postgresql-${var.name}"
  instance        = google_sql_database_instance.db_instance.name
  charset         = "UTF8"
  collation       = "en_US.UTF8"
  deletion_policy = local.deletion_policy # DELETE or ABANDON (better)
  depends_on = [
    google_sql_user.dbuser
  ]
}

# https://cloud.google.com/sql/docs/postgres/connect-overview
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "db_instance" {
  name                = "tf-postgresql-${var.name}-instance"
  region              = var.region
  database_version    = var.engine
  deletion_protection = var.deletion_protection

  settings {
    tier    = var.machine_size
    edition = var.edition
    #user_labels = "test"
    activation_policy            = "ALWAYS"
    availability_type            = var.availability
    connector_enforcement        = "NOT_REQUIRED"
    deletion_protection_enabled  = var.deletion_protection
    enable_google_ml_integration = false
    disk_autoresize              = true
    disk_autoresize_limit        = 0
    disk_size                    = var.disk_size
    disk_type                    = var.disk_type
    pricing_plan                 = "PER_USE"

    # https://cloud.google.com/sql/docs/postgres/flags#terraform
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }
    database_flags {
      name  = "log_min_error_statement"
      value = "error"
    }
    database_flags {
      name  = "log_temp_files"
      value = "0"
    }

    backup_configuration {
      enabled                        = true
      start_time                     = var.backup_time
      point_in_time_recovery_enabled = false
      location                       = var.region
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = var.backup_count
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      # This gives a public IP
      # Yes, this seems like a bad idea but GCP recommends it
      # We'll find an alternative way to access on VPC via VPN
      # TODO: Private IP
      ipv4_enabled = true
      # private_network {}
      # TODO: Enable Mutual-Client TLS/SSL
      # https://cloud.google.com/sql/docs/postgres/admin-api/rest/v1beta4/instances#ipconfiguration
      #require_ssl = true (deprecated)
      ssl_mode = "ENCRYPTED_ONLY" # SSL Only
      # TODO: Client Cert Auth
      # ssl_mode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = "stable" # You probably should not change this
    }
  }
}
