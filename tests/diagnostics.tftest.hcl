variables {
  name                = "acr"
  resource_group_name = "simpleacr-rg"
  location            = "westeurope"

  diagnostics = {
    destination   = "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/XXXXXXXXXX/providers/Microsoft.OperationalInsights/workspaces/XXXXXXXXXX"
    eventhub_name = null
    logs          = ["ContainerRegistryRepositoryEvents", "ContainerRegistryLoginEvents"]
    metrics       = ["all"]
  }
}


run "diagnostics" {
  command = plan

}
