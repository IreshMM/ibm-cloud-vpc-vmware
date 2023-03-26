output "esxi_host_password" {
  value     = data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password
  sensitive = true
}

output "esxi_host_hostname" {
  value = var.esxi_host_hostname
}

output "esxi_host_ip" {
  value = var.esxi_host_ip
}

output "vcenter_nic_ip" {
  value = var.vcenter_nic_ip
}