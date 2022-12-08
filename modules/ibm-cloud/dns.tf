resource "ibm_resource_instance" "vmware-dns" {
  name              = "vmware-dns"
  service           = "dns-svcs"
  plan              = "standard-dns"
  resource_group_id = ibm_resource_group.VMware.id
  location          = "global"
}

resource "ibm_dns_zone" "vmware-dns-zone" {
    name = "vmware.ibmcloud.local"
    instance_id = ibm_resource_instance.vmware-dns.guid
    description = "Zone for VMware on VPC"
}

resource "ibm_dns_permitted_network" "vmware-dns-zone-permitted-network" {
    instance_id = ibm_resource_instance.vmware-dns.guid
    zone_id = ibm_dns_zone.vmware-dns-zone.zone_id
    vpc_crn = ibm_is_vpc.vmw-apic.crn
    type = "vpc"
}

resource "ibm_dns_resource_record" "esxi-host-record" {
  instance_id = ibm_resource_instance.vmware-dns.guid
  zone_id     = ibm_dns_zone.vmware-dns-zone.zone_id
  type        = "A"
  name        = "esxi-host"
  rdata       = ibm_is_bare_metal_server.esxi-host.primary_network_interface[0].primary_ip[0].address
}

resource "ibm_dns_resource_record" "vcenter-record" {
  instance_id = ibm_resource_instance.vmware-dns.guid
  zone_id     = ibm_dns_zone.vmware-dns-zone.zone_id
  type        = "A"
  name        = "vcenter"
  rdata       = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
}

resource "ibm_dns_resource_record" "vcenter-record-reverse" {
  depends_on = [ ibm_dns_resource_record.vcenter-record ]
  instance_id = ibm_resource_instance.vmware-dns.guid
  zone_id     = ibm_dns_zone.vmware-dns-zone.zone_id
  type        = "PTR"
  name        = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
  rdata       = "vcenter.${ibm_dns_zone.vmware-dns-zone.name}"
}

resource "ibm_dns_resource_record" "jump-host-record" {
  instance_id = ibm_resource_instance.vmware-dns.guid
  zone_id     = ibm_dns_zone.vmware-dns-zone.zone_id
  type        = "A"
  name        = "jump-host"
  rdata       = ibm_is_instance.jump-host.primary_network_interface[0].primary_ipv4_address
}