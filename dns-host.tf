resource "ibm_is_instance" "dns-host" {
  name    = "dns-host"
  image   = "r010-ee20fadd-95ed-4aa2-a98c-e33bc2a96e69"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.vmw-mgmt-subnet.id
    primary_ipv4_address = "10.1.2.5"
    allow_ip_spoofing = false
  }
  vpc            = ibm_is_vpc.vmw.id
  zone           = var.zone
  keys           = [ibm_is_ssh_key.iresh-pc.id]
  resource_group = ibm_resource_group.VMware.id
}