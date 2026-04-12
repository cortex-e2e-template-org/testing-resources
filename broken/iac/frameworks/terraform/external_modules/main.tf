module "terragoat_module" {
  source = "git::https://github.com/bridgecrewio/terraform-azurerm-bridgecrew-azure-read-only.git"
  bridgecrew_token = "test_token
  org_name  "tests"
