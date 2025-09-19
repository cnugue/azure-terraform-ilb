terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.100"
      }
    }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

locals {
  location          = var.location
}

module "rg" {
    source          = "./modules/resource_group"
    name            = var.resource_group_name
    location        = local.location
}

module "network" {
    source          = "./modules/network"
    rg_name         = module.rg.name
    location        = local.location
    vnet_name       = var.vnet_name
    subnet_name     = var.subnet_name
}

module "lb" {
    source          = "./modules/loadbalancer"
    rg_name         = module.rg.name
    location        = local.location
    lb_name         = var.lb_name
    subnet_id       = module.network.subnet_id
}

module "vm" {
    source          = "./modules/vm"
    rg_name         = module.rg.name
    location        = local.location
    subnet_id       = module.network.subnet_id
    lb_backend_pool = module.lb.backend_pool_id
    vm_size         = var.vm_size
    admin_username  = var.admin_username
    admin_password  = var.admin_password
}
