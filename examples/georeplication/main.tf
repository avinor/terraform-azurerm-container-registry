module "georeplication" {
  source = "../../"

  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"
  sku                 = "Premium"
  georeplications = [
    {
      location                  = "westeurope"
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = false
      tags                      = {}
    }
  ]
}
