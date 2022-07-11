resource "ibm_is_bare_metal_server" "BMS00X" {
  profile = "bx2d-metal-96x384"
  name    = "esx-00${count.index}"
  image   = "r010-3fe32f09-0937-49a8-a8e6-01572a416d2c"
  zone    = var.zone
  keys    = [ibm_is_ssh_key.cloud-workstation-1.id]
  primary_network_interface {
    name   = "pci-nic-vmnic0-vmk0"
    subnet = ibm_is_subnet.vmw-host-mgmt-subnet.id
    primary_ip {
      address = "10.97.0.1${count.index}"
      auto_delete = true
    }
    allowed_vlans = [ 100,200,300 ]
  }
  vpc   = ibm_is_vpc.vmw.id
  user_data = <<EOT
                # enable & start SSH
                vim-cmd hostsvc/enable_ssh
                vim-cmd hostsvc/start_ssh
                # enable & start ESXi Shell
                vim-cmd hostsvc/enable_esx_shell
                vim-cmd hostsvc/start_esx_shell
                # Attempting to set the hostname
                esxcli system hostname set --fqdn=esx-00${count.index}.vmware.ibmcloud.local
                EOT
  count = var.bare-metal-count
}

resource "ibm_is_bare_metal_server_network_interface" "vmotion-nics" {
  bare_metal_server = ibm_is_bare_metal_server.BMS00X[count.index].id
  subnet = ibm_is_subnet.vmw-vmot-subnet.id
  name   = "vlan-nic-vmotion-vmk2"
  vlan = 200
  allow_interface_to_float = false
  count = var.bare-metal-count
}

resource "ibm_is_bare_metal_server_network_interface" "vsan-nics" {
  bare_metal_server = ibm_is_bare_metal_server.BMS00X[count.index].id
  subnet = ibm_is_subnet.vmw-vsan-subnet.id
  name   = "vlan-nic-vsan-vmk3"
  vlan = 300
  allow_interface_to_float = false
  count = var.bare-metal-count
}

resource "ibm_is_bare_metal_server_network_interface" "vcenter-nic" {
  bare_metal_server = ibm_is_bare_metal_server.BMS00X[0].id
  subnet = ibm_is_subnet.vmw-inst-mgmt-subnet.id
  name   = "vlan-nic-vcenter"
  vlan = 100
  allow_interface_to_float = true
}