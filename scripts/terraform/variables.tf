variable "ENVIRONMENT" {
  type        = string
  sensitive   = false
  description = "Environment name."

  validation {
    condition     = var.ENVIRONMENT == "dev" || var.ENVIRONMENT == "prd"
    error_message = "Environement must be set to dev or prod"
  }
}

variable "LOCATION" {
  type        = string
  sensitive   = false
  description = "Region name."
}

variable "RESOURCE_GROUP_NAME" {
  type        = string
  sensitive   = false
  description = "Resource group name."
}

variable "PROJECT_NAME" {
  type        = string
  sensitive   = false
  description = "Project name."
}

# MySQL Database
variable "MYSQL_ADMIN_LOGIN" {
  type        = string
  sensitive   = false
  description = "Admin login."
}

variable "MYSQL_ADMIN_PASSWORD" {
  type        = string
  sensitive   = false
  description = "Admin password."
}