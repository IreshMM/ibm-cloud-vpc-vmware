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
    vpc_crn = ibm_is_vpc.vmw.crn
    type = "vpc"
}

resource "ibm_dns_resource_record" "test-pdns-resource-record-a" {
  instance_id = ibm_resource_instance.vmware-dns.guid
  zone_id     = ibm_dns_zone.vmware-dns-zone.zone_id
  type        = "A"
  name        = "testA"
  rdata       = "1.2.3.4"
}