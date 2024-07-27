
# This pipeline builds a Vite/React app, syncs to storage bucket, and invalidates CDN cache

module "frontend_pipeline" {
  source         = "./modules/pipeline"
  project_id     = var.project_id
  project_number = var.project_number
  ###
  name               = "pipeline-frontend"
  repo_provider      = "github-ottojs"
  repo_owner         = "ottojs"
  repo_name          = "frontend-react"
  container_registry = var.project_id
  build_container    = var.build_container
  timeout            = "1800s" # 30min
  steps = [
    {
      id         = "config"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
      entrypoint = "/bin/bash"
      args = [
        "-c",
        "/bin/echo -e 'VITE_API_URL=https://${var.domain_api}\nVITE_CDN_URL=https://${var.domain_app}' > .env.production",
      ]
    },
    {
      id   = "build"
      name = var.build_container
      args = [
        "npm",
        "run",
        "deploy",
        "--if-present",
      ]
    },
    {
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
        "gs://${module.frontend_bucket.domain}",
      ]
    },
    {
      id         = "clear-cdn-cache"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "compute",
        "url-maps",
        "invalidate-cdn-cache",
        module.frontend_load_balancer.url_map_https_name,
        "--path",
        "/*",
        # Optional
        "--host",
        module.frontend_bucket.domain,
      ]
      # Takes about 10min to clear cache
      # We'll set timeout to 20min
      timeout = "1200s"
    }
  ]
}
