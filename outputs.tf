output "resource_group" {
  value = module.rg.name
}

output "loadbalancer" {
  value = module.lb.backend_pool_id
}

output "vm_private_ips" {
  value = module.vm.private_ips
}