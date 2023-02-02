output "jump_host_fip" {
  value = module.common.jump_host_fip
}

output "vcenter_ip" {
  value = module.vsphere-site.vcenter_ip
}

output "vcenter_fqdn" {
  value = module.vsphere-site.vcenter_fqdn
}

output "vcenter_domain" {
  value = module.vsphere-site.vcenter_domain
}

output "esxi_host_fqdn" {
  value = module.vsphere-site.esxi_host_fqdn
}

output "esxi_host_password" {
  value     = module.vsphere-site.esxi_host_password
  sensitive = true
}
