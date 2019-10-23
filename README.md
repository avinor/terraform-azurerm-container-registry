# Azure Container Registry

This module is just a thin wrapper around the `azurerm_container_registry` resource to enforce naming standards and security policies (no admin user enabled). It can also assign roles for pulling and pushing images.

## Requirements

- Minimum **Contributor** access to create registry
- **Owner** required when using *roles* variable

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

[ACR support content trust](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-content-trust) on registries with Premium sku. This module will enable content trust when `content_trust` variable is set to true. Just enabling is not enough though. For configuring content trust additional setup needs to be done after.

- Grant temporary role `AcrImageSigner` permission on registry to your user
- Run `az acr login --name <name>`. Run after assigning role to get correct token.
- Set `export DOCKER_CONTENT_TRUST=1`
- Build an image and push to new registry
  - It will ask for root and repository passphrase. Generate a new random strong passphrase
  - Make sure to write down these passphrases somewhere
- Backup private keys for content trust
  - Create archive: `umask 077; tar -zcvf docker_private_keys_backup.tar.gz -C $HOME/.docker/trust/private .; umask 022`
  - Store in a secure way
- Remove temporary role `AcrImageSigner` from registry

For using content trust in CI/CD process:

- Create a delegated key pair for signing in pipeline: `docker trust key generate pipeline`
- Find private key file in docker trust folder: `grep pipeline ~/.docker/trust/private/*`
- Add private key, delegated key passphrase and root passphrase as secrets in CI process
- Save the public key generated in repository or anywhere it is required when signing images

When using in pipeline make sure the private key is stored in `$HOME/.docker/trust/private` and define environment variables `DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE` and `DOCKER_CONTENT_TRUST_ROOT_PASSPHRASE`. This allows pipeline to sign and push images.

Before pushing a new signed image the repository always needs to be initialized first. Run `docker trust signer add --key pipeline.pub pipeline <image_name>`, where pipeline.pub is the public key and pipeline is name of delegated user created earlier.

## References

- <https://docs.microsoft.com/en-us/azure/container-registry/container-registry-content-trust>
- <https://docs.docker.com/engine/security/trust/content_trust>
- <https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/containers/content-trust?view=azure-devops>
- <https://docs.docker.com/engine/security/trust/trust_delegation/#using-docker-trust-to-generate-keys>