resource "ibm_is_instance" "jump-001" {
  name    = "jump-001"
  image   = "r010-9891fe13-fc3a-4106-a154-f66f5a5a8fe8"
  profile = "bx2-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.vmw-inst-mgmt-subnet.id
  }

  vpc  = ibm_is_vpc.vmw.id
  zone = var.zone
  keys = [ibm_is_ssh_key.cloud-workstation-1.id]
}

resource "ibm_is_floating_ip" "jump-001-fip" {
  name   = "jump-001-fip"
  target = ibm_is_instance.jump-001.primary_network_interface[0].id
}