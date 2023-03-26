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

resource "ibm_dns_resource_record" "esxi-host-records" {
  count       = var.esxi_host_count
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "A"
  name        = local.esxi_host_info[count.index].esxi_host_hostname 
  rdata       = local.esxi_host_info[count.index].esxi_host_ip
}

resource "ibm_dns_resource_record" "vcenter-record" {
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "A"
  name        = "vcenter"
  rdata       = local.esxi_host_info[0].vcenter_nic_ip
}

resource "ibm_dns_resource_record" "vcenter-record-reverse" {
  depends_on  = [ibm_dns_resource_record.vcenter-record]
  instance_id = var.dns_service_guid
  zone_id     = ibm_dns_zone.vmware-site-dns-zone.zone_id
  type        = "PTR"
  name        = local.esxi_host_info[0].vcenter_nic_ip
  rdata       = "vcenter.${ibm_dns_zone.vmware-site-dns-zone.name}"
}