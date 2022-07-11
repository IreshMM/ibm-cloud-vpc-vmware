resource "ibm_is_instance" "jump-001" {
  name    = "jump-001"
  image   = "r010-eaebade7-d050-4e4d-b552-c45e53c9a893"
  profile = "bx2-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.vmw-inst-mgmt-subnet.id
  }

  network_interfaces {
    name = "eth1"
    allow_ip_spoofing = false
    subnet = ibm_is_subnet.vmw-vmot-subnet.id
  }

  vpc  = ibm_is_vpc.vmw.id
  zone = var.zone
  keys = [ibm_is_ssh_key.cloud-workstation-1.id, "r010-603b53db-11e3-4d41-83e0-626c219412a7"]
}

resource "ibm_is_floating_ip" "jump-001-fip" {
  name   = "jump-001-fip"
  target = ibm_is_instance.jump-001.primary_network_interface[0].id
}

data "ibm_is_instance_network_interface" "jump-001-nic" {
    instance_name = ibm_is_instance.jump-001.name
    network_interface_name = ibm_is_instance.jump-001.primary_network_interface[0].name
}

resource "ibm_is_security_group_rule" "allow-ssh" {
  group     = data.ibm_is_instance_network_interface.jump-001-nic.security_groups[0].id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}