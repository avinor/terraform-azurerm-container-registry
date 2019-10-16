# Azure Container Registry

This module is just a thin wrapper around the `azurerm_container_registry` resource to enforce naming standards and security policies (no admin user enabled). It can also assign roles for pulling and pushing images.

## Usage

Example using [tau](https://github.com/avinor/tau) for deployment

```terraform
module {
    source = "avinor/container-registry/azurerm"
    version = "1.1.0"
}

inputs {
    name = "acr"
    resource_group_name = "simpleacr-rg"
    location = "westeurope"

    roles = [
        {
            object_id = "0000-0000-0000"
            role = "AcrPull"
        },
    ]
}
```

## Roles

Using `roles` input variable it is possible to assign any role to the container registry. It is primarily meant for assigning Acr* roles though, pulling and pushing images.

## Docker Content Trust

[ACR support content trust](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-content-trust) on registries with Premium sku. To enable content trust set variable `content_trust` to true and assign the `AcrImageSigner` role to users that are allowed to sign images.
