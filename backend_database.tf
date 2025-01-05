
module "backend_database" {
  source              = "./modules/sql_database"
  name                = "backend-db"
  deletion_protection = var.deletion_protection

  # Only PostgreSQL is supported
  # v17.x is the newest stable version as of writing
  # You must supply a value here to ensure you're aware of major version upgrades
  # https://cloud.google.com/sql/docs/postgres/db-versions
  engine = "POSTGRES_17"

  # Optional and used for reducing cost
  # Probably delete this section if you're doing a production deploy
  edition      = "ENTERPRISE"
  availability = "ZONAL"
  machine_size = "db-f1-micro"
  disk_size    = 10
}
