
variable "name" {
  description = "Name of database deployment"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-central1"
}

variable "deletion_protection" {
  description = "boolean to determine if there is deletion protection"
  type        = string
}

# https://cloud.google.com/sql/docs/postgres/editions-intro
# ENTERPRISE or ENTERPRISE_PLUS (better)
variable "edition" {
  description = "Database Edition"
  type        = string
  default     = "ENTERPRISE_PLUS"
}

# ZONAL or REGIONAL (better) - Regional is High Availability
variable "availability" {
  description = "Database Availability"
  type        = string
  default     = "REGIONAL"
}

# https://cloud.google.com/sql/pricing
# https://cloud.google.com/sdk/gcloud/reference/sql/tiers/list
#
# See all available machine types
# gcloud sql tiers list
#
# Declare a custom machine type
# https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type#create
variable "machine_size" {
  description = "Database instance size"
  type        = string
  default     = "db-g1-small"
  # db-g1-small
  # RAM: 1.7 GiB
  # DISK: 3.0 TiB
}

variable "engine" {
  description = "Database Engine to use"
  type        = string
}

variable "disk_size" {
  description = "disk_size"
  type        = number
  default     = 20 # Gigabytes
}

variable "disk_type" {
  description = "disk_type"
  type        = string
  default     = "PD_SSD"
}

variable "backup_time" {
  description = "backup_time"
  type        = string
  default     = "03:00"
}

variable "backup_count" {
  description = "backup_count"
  type        = number
  default     = 30
}

# 2 = Tuesday (1-7, starting Monday)
variable "maintenance_window_day" {
  description = "maintenance_window_day"
  type        = number
  default     = 2
}

# 0-23, this option requires "day" to be specified (and you probably should)
# 3 = 3AM
variable "maintenance_window_hour" {
  description = "maintenance_window_hour"
  type        = number
  default     = 3
}

locals {
  # DELETE, ABANDON, and sometimes DISABLE
  deletion_policy = var.deletion_protection == true ? "ABANDON" : "DELETE"
}
