output "vcenter_ip" {
  value = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
}

output "vcenter_fqdn" {
  value = ibm_dns_resource_record.vcenter-record.name
}

output "vcenter_domain" {
  value = ibm_dns_zone.vmware-site-dns-zone.name
}

output "esxi_host_fqdn" {
  value = ibm_dns_resource_record.esxi-host-record.name
}

output "esxi_host_password" {
  value     = data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password
  sensitive = true
}

output "apic_subsys_nics" {
  value = ibm_is_bare_metal_server_network_interface.apic-subsys-nics
}