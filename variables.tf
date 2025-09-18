# General
variable "resource_group_name" {
    description = "Nmae of the resource group"
    type        = string
}

variable "location" {
    description = "Azure region"
    type        = string 
}

# Networking
variable "vnet_name" {
    description = "Subnet name"
    type        = string 
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

# Load Balancer
variable "lb_name" {
  description = "Internal load balancer name"
  type        = string
}

# VM Settings
variable "vm_size" {
  description = "Size of the VMs"
  type        = string
}

variable "admin_username" {
  description = "Admin username for Windows VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}