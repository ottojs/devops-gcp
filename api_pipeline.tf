
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

#    # Using Secrets
#    # https://cloud.google.com/build/docs/securing-builds/use-secrets
#    available_secrets {
#      secret_manager {
#        env          = "MYSECRET"
#        version_name = "projects/${var.project_id}/secrets/SECRETNAMEHERE/versions/latest"
#      }
#    }
#    step {
#      id   = "secret-data"
#      name = var.pipeline_build_container
#      entrypoint = "sh"
#      args = [
#        "-c",
#        "echo $$MYSECRET"
#      ]
#      secret_env = ["MYSECRET"]
#    }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository
resource "google_cloudbuildv2_repository" "api" {
  name              = var.api_repo_name
  location          = var.region
  parent_connection = var.repo_provider
  remote_uri        = "${var.repo_url_prefix}/${var.api_repo_owner}/${var.api_repo_name}.git"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "api" {
  name        = "pipeline-${var.api_repo_name}"
  description = "Pipeline ${var.api_repo_name}"
  location    = var.region
  # TODO: Check system-level service account
  service_account = "projects/${var.project_id}/serviceAccounts/${var.project_number}-compute@developer.gserviceaccount.com"

  repository_event_config {
    # Format: "projects/PROJECTID/locations/REGION/connections/PROVIDER/repositories/NAME"
    repository = google_cloudbuildv2_repository.api.id
    push {
      branch       = var.repo_branch
      invert_regex = false
    }
  }

  # Uses named file in code repository
  # We don't use this method because we want access to the Terraform variables
  # filename = "cloudbuild.yml"

  build {
    # 10min
    timeout = "600s"

    options {
      machine_type = "E2_MEDIUM"
      logging      = "CLOUD_LOGGING_ONLY"
    }

    step {
      id   = "build"
      name = var.pipeline_build_container
      args = [
        "npm",
        "install",
      ]
    }

    step {
      id   = "test"
      name = var.pipeline_build_container
      args = [
        "npm",
        "test",
      ]
    }

    step {
      id   = "build-image"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:$SHORT_SHA",
        ".",
      ]
    }

    step {
      id   = "tag-latest"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "tag",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:$SHORT_SHA",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:latest",
      ]
    }

    step {
      id   = "push-sha"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:$SHORT_SHA",
      ]
    }

    step {
      id   = "push-latest"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:latest",
      ]
    }

    step {
      id         = "deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        local.api_name,
        "--image",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:latest",
        "--region",
        var.region,
      ]
    }

    # We could use this to push but use steps instead
    # Reason why: We want to push built images before deploy in case deploy fails
    # artifacts {
    #   images = [
    #     "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:$SHORT_SHA",
    #     "${var.region}-docker.pkg.dev/${var.project_id}/${var.container_registry}/${var.api_repo_name}:latest",
    #   ]
    # }

  }
}
