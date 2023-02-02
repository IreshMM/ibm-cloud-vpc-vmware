output "jump_host_fip" {
  value = module.ibm-cloud-infr.jump_host_fip
}

output "vcenter_ip" {
  value = module.ibm-cloud-infr.vcenter_ip
}

output "vcenter_fqdn" {
  value = module.ibm-cloud-infr.vcenter_fqdn
}

output "esxi_host_password" {
  value     = module.ibm-cloud-infr.esxi_host_password
  sensitive = true
}
