
##############################
##### DB PASSWORD SECRET #####
##############################

# Load Secret: DB Password
# Used to load a pre-existing secret
# data "google_secret_manager_secret_version" "db_loader" {
#   secret = "db-user-password"
# }

# https://registry.terraform.io/providers/hashicorp/random/latest/docs
resource "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
resource "google_secret_manager_secret" "db" {
  secret_id = "db-user-password"
  labels = {
    creator = "tf"
  }
  replication {
    auto {}
  }
  #annotations = {}
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version
resource "google_secret_manager_secret_version" "db" {
  secret      = google_secret_manager_secret.db.id
  secret_data = random_password.db.result
  # DELETE, ABANDON, DISABLE
  deletion_policy = local.deletion_policy
}
