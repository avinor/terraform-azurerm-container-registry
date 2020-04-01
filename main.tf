terraform {
  required_version = ">= 0.12.6"
  required_providers {
    azurerm = "~> 1.44.0"
  }
}

locals {
  roles_map = { for role in var.roles : "${role.object_id}.${role.role}" => role }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "acr" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                     = format("%sregistry", lower(replace(var.name, "/[[:^alnum:]]/", "")))
  resource_group_name      = azurerm_resource_group.acr.name
  location                 = azurerm_resource_group.acr.location
  sku                      = var.sku
  admin_enabled            = false
  georeplication_locations = var.georeplication_locations

  tags = var.tags
}

resource "null_resource" "trust" {
  count = ! var.content_trust && var.sku == "Standard" ? 0 : 1

  triggers = {
    content_trust = var.content_trust
  }

  # TODO Use new resource when exists
  provisioner "local-exec" {
    command = "az acr config content-trust update --name ${azurerm_container_registry.acr.name} --status ${var.content_trust ? "enabled" : "disabled"} --subscription ${data.azurerm_client_config.current.subscription_id}"
  }

  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_role_assignment" "roles" {
  for_each = local.roles_map

  scope                = azurerm_container_registry.acr.id
  role_definition_name = each.value.role
  principal_id         = each.value.object_id
}
