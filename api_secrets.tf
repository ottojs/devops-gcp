
##############################
##### DB PASSWORD SECRET #####
##############################

# https://registry.terraform.io/providers/hashicorp/random/latest/docs
resource "random_password" "apidb" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
resource "google_secret_manager_secret" "apidb" {
  secret_id = "api-db-user-password"
  labels = {
    creator = "tf"
  }
  replication {
    auto {}
  }
  #annotations = {}
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version
resource "google_secret_manager_secret_version" "apidb" {
  secret      = google_secret_manager_secret.apidb.id
  secret_data = random_password.apidb.result
  # DELETE, ABANDON, DISABLE
  deletion_policy = local.deletion_policy
}

#########################
##### COOKIE SECRET #####
#########################

# https://registry.terraform.io/providers/hashicorp/random/latest/docs
resource "random_password" "cookie" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
resource "google_secret_manager_secret" "cookie" {
  secret_id = "api-cookie-secret"
  labels = {
    creator = "tf"
  }
  replication {
    auto {}
  }
  #annotations = {}
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version
resource "google_secret_manager_secret_version" "cookie" {
  secret      = google_secret_manager_secret.cookie.id
  secret_data = random_password.cookie.result
  # DELETE, ABANDON, DISABLE
  deletion_policy = local.deletion_policy
}

#######################
##### CSRF SECRET #####
#######################

# https://registry.terraform.io/providers/hashicorp/random/latest/docs
resource "random_password" "csrf" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
resource "google_secret_manager_secret" "csrf" {
  secret_id = "api-csrf-secret"
  labels = {
    creator = "tf"
  }
  replication {
    auto {}
  }
  #annotations = {}
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version
resource "google_secret_manager_secret_version" "csrf" {
  secret      = google_secret_manager_secret.csrf.id
  secret_data = random_password.csrf.result
  # DELETE, ABANDON, DISABLE
  deletion_policy = local.deletion_policy
}
