output "vcenter_ip" {
  value = module.esxi-host[0].vcenter_nic_ip
}

output "vcenter_fqdn" {
  value = ibm_dns_resource_record.vcenter-record.name
}

output "vcenter_domain" {
  value = ibm_dns_zone.vmware-site-dns-zone.name
}

output "esxi_host_fqdns" {
  value = [for host in module.esxi-host: "${host.esxi_host_hostname}.${ibm_dns_zone.vmware-site-dns-zone.name}"]
}

output "esxi_host_passwords" {
  value     = module.esxi-host[*].esxi_host_password
  sensitive = true
}