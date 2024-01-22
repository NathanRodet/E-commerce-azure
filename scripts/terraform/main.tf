resource "random_pet" "prefix" {}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.PROJECT_NAME}${var.ENVIRONMENT}${var.LOCATION}001"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  sku                 = "Basic"
  admin_enabled       = false

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.ENVIRONMENT
    project     = var.PROJECT_NAME
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.PROJECT_NAME}-${var.ENVIRONMENT}-${var.LOCATION}-001"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION

  sku_tier   = "Standard"
  dns_prefix = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name = "default"

    vm_size = var.ENVIRONMENT == "prd" ? "Standard_B2s" : "Standard_B2s"

    enable_auto_scaling = true
    # Match the client prerequisites
    max_count       = var.ENVIRONMENT == "prd" ? 5 : var.ENVIRONMENT == "dev" ? 5 : null
    min_count       = var.ENVIRONMENT == "prd" ? 3 : var.ENVIRONMENT == "dev" ? 3 : null
    max_pods        = var.ENVIRONMENT == "prd" ? 60 : var.ENVIRONMENT == "dev" ? 60 : null
    os_disk_size_gb = "30"
  }

  auto_scaler_profile {
    scan_interval               = "10s"
    balance_similar_node_groups = false
    expander                    = var.ENVIRONMENT == "prd" ? "random" : var.ENVIRONMENT == "dev" ? "least-waste" : null 
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.ENVIRONMENT
    project     = var.PROJECT_NAME
  }
}


resource "azurerm_mysql_server" "mysql_server" {
  name                = "sqlserver-${var.PROJECT_NAME}-${var.ENVIRONMENT}-${var.LOCATION}"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  administrator_login          =  var.MYSQL_ADMIN_LOGIN
  administrator_login_password =  var.MYSQL_ADMIN_PASSWORD

  sku_name   = var.ENVIRONMENT == "prd" ? "B_Gen5_1" : var.ENVIRONMENT == "dev" ? "B_Gen5_2" : null
  storage_mb = 5120  
  version    = "5.7"

  auto_grow_enabled                 = false # Free tier.
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  # Because we will not pay a custom domain and a certificate for this project, we will not enable SSL.
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.ENVIRONMENT
    project     = var.PROJECT_NAME
  }
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = "onlineboutiquedb${var.ENVIRONMENT}"
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on = [ azurerm_mysql_server.mysql_server ]
}

# Allow all internal azure services to access the MySQL Database
resource "azurerm_mysql_firewall_rule" "firewall_rule_allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_mysql_server.mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  depends_on = [ azurerm_mysql_server.mysql_server, azurerm_mysql_database.mysql_database ]
}