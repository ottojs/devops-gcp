
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloud_run_v2_service
resource "google_cloud_run_v2_service" "api" {
  name     = local.api_name
  location = var.region
  project  = var.project_id

  # OPEN TO PUBLIC (intentionally)
  ingress = "INGRESS_TRAFFIC_ALL"

  lifecycle {
    ignore_changes = [
      # These are populated by the pipeline
      client,
      client_version,
    ]
  }

  template {
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    service_account                  = google_service_account.api.email
    timeout                          = "30s"
    max_instance_request_concurrency = 100
    annotations                      = {}
    labels                           = {}
    session_affinity                 = false

    scaling {
      min_instance_count = var.api_count_min
      max_instance_count = var.api_count_max
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.apidb_instance.connection_name]
      }
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:latest"
      #args       = []
      #command    = []
      #depends_on = []

      resources {
        limits = {
          cpu    = var.api_cpu
          memory = var.api_memory
        }
        cpu_idle          = true
        startup_cpu_boost = true
      }
      ports {
        # "h2c"
        name           = "http1"
        container_port = 8080
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "SQL_URI"
        value = "GCP"
      }
      env {
        name  = "SQL_USERNAME"
        value = google_sql_user.api_dbuser.name
      }
      env {
        name = "SQL_PASSWORD"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.apidb.secret_id
            # latest
            version = google_secret_manager_secret_version.apidb.version
          }
        }
      }
      env {
        name  = "SQL_DATABASE"
        value = google_sql_database.apidb.name
      }
      env {
        name  = "SQL_CONNNAME"
        value = google_sql_database_instance.apidb_instance.connection_name
      }
      # User-provided key:values
      dynamic "env" {
        for_each = var.api_envvars_plain
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
      dynamic "env" {
        for_each = var.api_envvars_secret
        content {
          name = env.value.name
          value_source {
            secret_key_ref {
              secret  = env.value.value
              version = "latest"
            }
          }
        }
      }

    }
  }
}

# Allow Public Access
# https://cloud.google.com/run/docs/authenticating/public#terraform
resource "google_cloud_run_service_iam_member" "api" {
  location = google_cloud_run_v2_service.api.location
  service  = google_cloud_run_v2_service.api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Domain
# NOTE: You could also pipe this through the Load Balancer
#       We do not do that here for purposes of illustration
#       The downside to this approach is if you need to replace
#       this service, it is possible the certificate will be replaced too
resource "google_cloud_run_domain_mapping" "api" {
  name     = var.api_domain
  project  = var.project_id
  location = var.region
  metadata {
    namespace = var.project_id
  }
  spec {
    force_override   = false
    route_name       = google_cloud_run_v2_service.api.name
    certificate_mode = "AUTOMATIC"
  }
  depends_on = [
    google_cloud_run_v2_service.api
  ]
}
