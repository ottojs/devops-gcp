
module "container_registry" {
  source         = "./modules/container_registry"
  project_id     = var.project_id
  project_number = var.project_number
  region         = var.region
  name           = var.project_id
}
