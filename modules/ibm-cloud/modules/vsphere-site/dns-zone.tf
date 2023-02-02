resource "ibm_dns_zone" "vmware-site-dns-zone" {
  name        = "${var.site_name}.vmware.ibmcloud.local"
  instance_id = var.dns_service_guid
  description = "Zone for VMware site on VPC"
}

resource "ibm_dns_permitted_network" "vmware-site-dns-zone-permitted-network" {
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  vpc_crn     = var.vmware_vpc_crn
  type        = "vpc"
}

resource "ibm_dns_resource_record" "esxi-host-record" {
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "A"
  name        = "esxi-host0"
  rdata       = ibm_is_bare_metal_server.esxi-host.primary_network_interface[0].primary_ip[0].address
}

resource "ibm_dns_resource_record" "vcenter-record" {
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "A"
  name        = "vcenter"
  rdata       = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
}

resource "ibm_dns_resource_record" "vcenter-record-reverse" {
  depends_on  = [ibm_dns_resource_record.vcenter-record]
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "PTR"
  name        = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
  rdata       = "vcenter.${ibm_dns_zone.vmware-site-dns-zone.name}"
}