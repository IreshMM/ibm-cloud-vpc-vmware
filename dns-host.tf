resource "ibm_is_instance" "dns-host" {
  name    = "dns-host"
  image   = "r010-ee20fadd-95ed-4aa2-a98c-e33bc2a96e69"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.vmw-mgmt-subnet.id
    allow_ip_spoofing = false
    primary_ip {
      address = "10.1.2.5"
      auto_delete = true
    }
  }
  vpc            = ibm_is_vpc.vmw.id
  zone           = var.zone
  keys           = [data.ibm_is_ssh_key.iresh-pc.id]
  resource_group = ibm_resource_group.VMware.id
}