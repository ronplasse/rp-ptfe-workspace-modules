variable "name" {}
variable "location" {}
variable "username" {}
variable "password" {}

provider "azurerm" {
  features {}
}

variable "vnet_address_spacing" {
  type = "list"
}

variable "subnet_address_prefixes" {
  type = "list"
}

module "rpnetworking" {
  source  = "app.terraform.io/ftfcu-training/rpnetworking/azurerm"
  version = "0.12.0"

  name                    = var.name
  location                = var.location
  vnet_address_spacing    = var.vnet_address_spacing
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "rpwebserver" {
  source  = "app.terraform.io/ftfcu-training/rpwebserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.rpnetworking.subnet-ids[0]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

module "rpappserver" {
  source  = "app.terraform.io/ftfcu-training/rpappserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.rpnetworking.subnet-ids[1]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

module "rpdataserver" {
  source  = "app.terraform.io/ftfcu-training/rpdataserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.rpnetworking.subnet-ids[2]
  vm_count  = 1
  username  = var.username
  password  = var.password
}
