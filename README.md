# Azure Container Registry

This module is just a thin wrapper around the `azurerm_container_registry` resource to enforce naming standards and security policies (no admin user enabled).

## Usage

```terraform
module "simple" {
    source = "avinor/container-registry/azurerm"
    version = "1.0.0"

    name = "acr"
    resource_group_name = "simpleacr-rg"
    location = "westeurope"
}
```