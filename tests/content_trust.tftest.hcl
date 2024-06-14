variables {
  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"

  sku           = "Premium"
  content_trust = true
}

run "content_trust" {
  command = plan

}
