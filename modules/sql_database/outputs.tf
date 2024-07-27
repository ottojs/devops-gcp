
output "instance" {
  value = google_sql_database_instance.db_instance
}

output "db_name" {
  value = google_sql_database.db.name
}

output "user_password_secret_id" {
  value = google_secret_manager_secret.db.secret_id
}

output "user_name" {
  value = google_sql_user.dbuser.name
}

output "connection_name" {
  value = google_sql_database_instance.db_instance.connection_name
}
