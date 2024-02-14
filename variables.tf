variable "resource_group_name" {
  type = string
  description = "resource group name in Azure"
}

variable "resource_group_location" {
  type = string
  description = "resource group location in Azure"
}

variable "app_service_plan_name" {
  type = string
  description = "app service plan name in Azure"
}

variable "app_service_name" {
  type = string
  description = "app service name in Azure"
}

variable "sql_server_name" {
  type = string
  description = "sql server name in Azure"
}

variable "sql_database_name" {
  type = string
  description = "sql db name in Azure"
}

variable "sql_admin_login" {
  type = string
  description = "sql server admin login in Azure"
}

variable "sql_admin_password" {
  type = string
  description = "password for the sql server admin login in Azure"
}

variable "firewall_rule_name" {
  type = string
  description = "firewall rule name in Azure"
}

variable "repo_URL" {
  type = string
  description = "URL to the Github repo"
}