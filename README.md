# Azure Container Registry

This module is just a thin wrapper around the `azurerm_container_registry` resource to enforce naming standards and security policies (no admin user enabled).

## Usage

Example using [tau](https://github.com/avinor/tau) for deployment

```terraform
module {
    source = "avinor/container-registry/azurerm"
    version = "1.0.0"
}

inputs {
    name = "acr"
    resource_group_name = "simpleacr-rg"
    location = "westeurope"
}
```
