module "simple" {
  source = "../../"

  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"
}