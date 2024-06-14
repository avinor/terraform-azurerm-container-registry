variables {
  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"
  sku                 = "Premium"
  georeplications = [
    {
      location                  = "northeurope"
      zone_redundancy_enabled   = true
      regional_endpoint_enabled = false
      tags                      = {}
    },
    {
      location                  = "italynorth"
      zone_redundancy_enabled   = false
      regional_endpoint_enabled = true
      tags                      = {}
    }
  ]
}


run "georeplication" {
  command = plan
}
