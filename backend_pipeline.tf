
# This pipeline builds and deploys a container image

locals {
  pipeline_backend_name      = "pipeline-backend"
  pipeline_backend_repo_name = "backend-node"
}

module "backend_pipeline" {
  source         = "./modules/pipeline"
  project_id     = var.project_id
  project_number = var.project_number
  ###
  name               = "pipeline-backend"
  repo_provider      = "github-ottojs"
  repo_owner         = "ottojs"
  repo_name          = local.pipeline_backend_repo_name
  container_registry = var.project_id
  build_container    = var.build_container
  steps = [
    {
      id   = "build"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:$SHORT_SHA",
        ".",
      ]
    },
    {
      id   = "tag-latest"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "tag",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:$SHORT_SHA",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:latest",
      ]
    },
    {
      id   = "push-sha"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:$SHORT_SHA",
      ]
    },
    {
      id   = "push-latest"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:latest",
      ]
    },
    {
      id         = "deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        local.pipeline_backend_name,
        "--image",
        "${var.region}-docker.pkg.dev/${var.project_id}/${local.container_registry}/${local.pipeline_backend_repo_name}:latest",
        "--region",
        var.region,
      ]
    }
  ]
}
