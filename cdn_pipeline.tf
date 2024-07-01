# Reference Cloud Build Config Format
# https://cloud.google.com/build/docs/build-config-file-schema
#
# Container Image Lists
# You can use an image's short name from Docker Hub too
# The source of the GCR container image "lists" are not clear
# If you know more, please open an issue or PR
# https://cloud.google.com/build/docs/cloud-builders
# https://console.cloud.google.com/gcr/images/google-containers/GLOBAL
# https://console.cloud.google.com/gcr/images/distroless/GLOBAL
# https://github.com/GoogleContainerTools
# gcloud container images list --project google-containers

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository
resource "google_cloudbuildv2_repository" "cdn" {
  name              = var.cdn_repo_name
  location          = var.region
  parent_connection = var.repo_provider
  remote_uri        = "${var.repo_url_prefix}/${var.cdn_repo_owner}/${var.cdn_repo_name}.git"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "cdn" {
  name        = "pipeline-${var.cdn_repo_name}"
  description = "Pipeline ${var.cdn_repo_name}"
  location    = var.region
  # TODO: Check system-level service account
  service_account = "projects/${var.project_id}/serviceAccounts/${var.project_number}-compute@developer.gserviceaccount.com"

  repository_event_config {
    # Format: "projects/PROJECTID/locations/REGION/connections/PROVIDER/repositories/NAME"
    repository = google_cloudbuildv2_repository.cdn.id
    push {
      branch       = var.repo_branch
      invert_regex = false
    }
  }

  # Uses named file in code repository
  # We don't use this method because we want access to the Terraform variables
  # filename = "cloudbuild.yml"

  build {
    # 30min
    timeout = "1800s"

    options {
      machine_type = "E2_MEDIUM"
      logging      = "CLOUD_LOGGING_ONLY"
    }

    step {
      id   = "install"
      name = var.pipeline_build_container
      args = [
        "npm",
        "ci",
      ]
    }

    step {
      id   = "config"
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
      entrypoint = "/bin/bash"
      args = [
        "-c",
        "/bin/echo -e 'VITE_API_URL=https://api.${var.domain_root}\nVITE_CDN_URL=https://cdn.${var.domain_root}' > .env.production",
      ]
    }

    step {
      id   = "build"
      name = var.pipeline_build_container
      args = [
        "npm",
        "run",
        "deploy",
      ]
    }

    step {
      id         = "deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gsutil"
      args = [
        "rsync",
        # Recursive Copy
        "-r",
        # Remove Extra/Dangling Files
        # "-d",
        "public",
        "gs://${google_storage_bucket.cdn.name}",
      ]
    }

    step {
      id         = "clear-cache"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "compute",
        "url-maps",
        "invalidate-cdn-cache",
        google_compute_url_map.lb_https.name,
        "--path",
        "/*",
        # Optional
        "--host",
        "${var.cdn_domain}",
      ]
      # Takes about 10min to clear cache
      # We'll set timeout to 20min
      timeout = "1200s"
    }

  }
}
