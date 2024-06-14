variables {
  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"
}


run "simple" {
  command = plan
}
