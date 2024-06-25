
##########################
##### IMPORTANT NOTE #####
##########################
# To make upgrades easier, you should only change these "variables_" files.
# If you need to make changes to the source files, please do so in a way
# that allows for customizations in these variable files unless the changes
# should be applied to all projects for reasons like security, performance, etc.

variable "cdn_domain" {
  description = "FQDN to host"
  default     = "cdn.example.com"
}

variable "cdn_repo_owner" {
  description = "Owner of repo"
  default     = "ryanlelek"
}

variable "cdn_repo_name" {
  description = "Name of repo"
  default     = "boilerplate-frontend-react"
}
