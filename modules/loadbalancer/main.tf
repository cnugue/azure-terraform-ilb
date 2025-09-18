resource "azurerm_lb" "ilb" {
    name                = var.lb_name
    location            = var.location
    resource_group_name = var.rg_name
    sku                 = "Standard" 

frontend_ip_configuration {
    name                = "iLB-Frontend"
    subnet_id           = var.subnet_id
    private_ip_address_allocation = var.rg_name
    }
}

resource "azurerm_lb_backend_address_pool" "BackendPool" {
  name                = "ilb-backendpool"
  loadbalancer_id     = azurerm_lb.ilb.id
}

resource "azurerm_lb_probe" "tcp" {
  name                = "tcp-probe"
  loadbalancer_id     = azurerm_lb.ilb.id
  protocol            = "Tcp"
  port                = 3389
}

resource "azurerm_lb_rule" "rdp" {
  name                           = "rdp-rule"
  loadbalancer_id                = azurerm_lb.ilb.id
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "iLB-Frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.BackendPool.id]
  probe_id                       = azurerm_lb_probe.tcp.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.BackendPool.id
}

variable "rg_name" {}
variable "location" {}
variable "lb_name" {}
variable "subnet_id" {}