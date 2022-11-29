resource "ibm_is_bare_metal_server" "esxi-host" {
  profile = "cx2d-metal-96x192"
  name    = "esxi-host"
  image   = "r010-3fe32f09-0937-49a8-a8e6-01572a416d2c"
  zone    = var.zone
  keys    = [data.ibm_is_ssh_key.iresh-pc.id]
  primary_network_interface {
    name   = "pci-nic-vmnic0-vmk0"
    subnet = ibm_is_subnet.vmw-host-subnet.id
    primary_ip {
      address     = "10.1.1.10"
      auto_delete = true
    }
    allowed_vlans = [100, 200, 300, 400]
  }
  vpc            = ibm_is_vpc.vmw-apic.id
  user_data      = <<EOT
                # enable & start SSH
                vim-cmd hostsvc/enable_ssh
                vim-cmd hostsvc/start_ssh
                # enable & start ESXi Shell
                vim-cmd hostsvc/enable_esx_shell
                vim-cmd hostsvc/start_esx_shell
                # Attempting to set the hostname
                esxcli system hostname set --fqdn=esxi-host.vmware.ibmcloud.local
                EOT
  resource_group = ibm_resource_group.VMware.id
}

resource "ibm_is_bare_metal_server_network_interface" "vcenter-nic" {
  bare_metal_server         = ibm_is_bare_metal_server.esxi-host.id
  allow_interface_to_float  = false
  allow_ip_spoofing         = false
  enable_infrastructure_nat = true
  name                      = "vmware-vcenter-nic"
  subnet                    = ibm_is_subnet.vmw-mgmt-subnet.id
  vlan                      = 100
  primary_ip {
    address     = "10.1.2.10"
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "apic-subsys-nics" {
  for_each = {
    apic-mgr-nic    = "192.168.72.11"
    apic-anytcs-nic = "192.168.72.12"
    apic-devptl-nic = "192.168.72.13"
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-subsys-subnet.id
  name                     = each.key
  vlan                     = 200
  allow_interface_to_float = false
  primary_ip {
    address     = each.value
    auto_delete = true
  }
  depends_on = [ibm_is_subnet.vmw-apic-subsys-subnet]
}

resource "ibm_is_bare_metal_server_network_interface" "apic-gw-frontend-nics" {
  for_each = {
    pr-apic-dpgw1-nic-frontend = "192.168.73.11"
    pr-apic-dpgw2-nic-frontend = "192.168.73.12"
    pr-apic-dpgw3-nic-frontend = "192.168.73.13"
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-gw-frontend-subnet.id
  name                     = each.key
  vlan                     = 300
  allow_interface_to_float = false
  primary_ip {
    address     = each.value
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "apic-gw-backend-nics" {
  for_each = {
    pr-apic-dpgw1-nic-backend = "192.168.73.139"
    pr-apic-dpgw2-nic-backend = "192.168.73.140"
    pr-apic-dpgw3-nic-backend = "192.168.73.141"
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-gw-backend-subnet.id
  name                     = each.key
  vlan                     = 400
  allow_interface_to_float = false
  primary_ip {
    address     = each.value
    auto_delete = true
  }
}
