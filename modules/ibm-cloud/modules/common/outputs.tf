output "vmware_vpc_id" {
  value = ibm_is_vpc.vmw-apic.id
}

output "vmware_vpc_crn" {
  value = ibm_is_vpc.vmw-apic.crn
}

output "ssh_key_id" {
  value = data.ibm_is_ssh_key.iresh-pc.id
}

output "public_gateway_id" {
  value = ibm_is_public_gateway.vmware-internet-outbound.id
}

output "jump_host_fip" {
  value = ibm_is_floating_ip.jump-host-fip.address
}

output "dns_service_guid" {
  value = ibm_resource_instance.vmware-dns.guid
}