
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloud_run_v2_service
resource "google_cloud_run_v2_service" "backend" {
  name     = var.name
  location = var.region
  project  = var.project_id
  # TODO: Does not apply successfully. Possible Bug. Need to edit on dashboard
  # annotations = {
  #   "run.googleapis.com/minScale" = var.count_min
  # }

  # OPEN TO PUBLIC (intentionally)
  ingress = "INGRESS_TRAFFIC_ALL"

  lifecycle {
    ignore_changes = [
      # These are populated by the pipeline on deploy
      client,
      client_version,
    ]
  }

  template {
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    service_account                  = google_service_account.backend.email
    timeout                          = "30s"
    max_instance_request_concurrency = 100
    annotations                      = {}
    labels = {
      creator : "tf"
    }
    session_affinity = false

    scaling {
      min_instance_count = var.count_min
      max_instance_count = var.count_max
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.db_instance.connection_name]
      }
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}/${var.container_image}:latest"
      #args       = []
      #command    = []
      #depends_on = []

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
        cpu_idle          = true
        startup_cpu_boost = true
      }
      ports {
        # "h2c"
        name           = "http1"
        container_port = var.listen_port
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      # User-provided key:values
      dynamic "env" {
        for_each = var.envvars_plain
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
      dynamic "env" {
        for_each = var.envvars_secret
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
