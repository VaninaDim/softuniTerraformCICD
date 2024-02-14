terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "task3rg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "azservicepln" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.task3rg.name
  location            = azurerm_resource_group.task3rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "task2webappvd" {
  name                = var.app_service_name
  location            = azurerm_resource_group.task3rg.location
  resource_group_name = azurerm_resource_group.task3rg.name
  service_plan_id     = azurerm_service_plan.azservicepln.id
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.task3vdserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.task3vddb.name};User ID=${azurerm_mssql_server.task3vdserver.administrator_login};Password=${azurerm_mssql_server.task3vdserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "contactbookrepo" {
  app_id                 = azurerm_linux_web_app.task2webappvd.id
  repo_url               = "https://github.com/VaninaDim/softuniTaskboardApp"
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "task3vdserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.task3rg.name
  location                     = azurerm_resource_group.task3rg.location
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  version                      = "12.0"
}

resource "azurerm_mssql_database" "task3vddb" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.task3vdserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "task3frwvd" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.task3vdserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
