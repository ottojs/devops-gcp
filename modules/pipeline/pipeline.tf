
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

# TODO: Integrate
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
#      name = var.build_container
#      entrypoint = "sh"
#      args = [
#        "-c",
#        "echo $$MYSECRET"
#      ]
#      secret_env = ["MYSECRET"]
#    }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository
resource "google_cloudbuildv2_repository" "pipeline" {
  name              = var.repo_name
  location          = var.region
  parent_connection = var.repo_provider
  remote_uri        = "${var.repo_url_prefix}/${var.repo_owner}/${var.repo_name}.git"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "pipeline" {
  name        = "pipeline-${var.repo_name}"
  description = "Pipeline ${var.repo_name}"
  location    = var.region
  tags        = ["tf"]
  # TODO: Check system-level service account
  service_account = "projects/${var.project_id}/serviceAccounts/${var.project_number}-compute@developer.gserviceaccount.com"

  repository_event_config {
    # Format: "projects/PROJECTID/locations/REGION/connections/PROVIDER/repositories/NAME"
    repository = google_cloudbuildv2_repository.pipeline.id
    push {
      branch       = var.repo_branch
      invert_regex = false
    }
  }

  # Uses named file in code repository
  # We don't use this method because we want access to the Terraform variables
  # filename = "cloudbuild.yml"

  build {
    timeout = var.timeout

    options {
      machine_type = var.machine_type
      logging      = var.logging
    }

    step {
      id   = "install"
      name = var.build_container
      args = [
        "npm",
        "ci",
      ]
    }

    step {
      id   = "test"
      name = var.build_container
      args = [
        "npm",
        "run",
        "test",
        "--if-present",
      ]
    }

    dynamic "step" {
      for_each = var.steps
      content {
        id   = step.value.id
        name = step.value.name
        args = step.value.args
      }
    }

    # We could use this to push container images but use steps instead
    # Reason why: We want to push built images before deploy in case deploy fails
    # artifacts {
    #   images = [
    #     "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}/${var.repo_name}:$SHORT_SHA",
    #     "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}/${var.repo_name}:latest",
    #   ]
    # }

  }
}
