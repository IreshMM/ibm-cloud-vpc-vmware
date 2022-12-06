resource "ibm_is_bare_metal_server" "esxi-host" {
  profile = "cx2-metal-96x192"
  name    = "esxi-host"
  image   = "r006-41460465-7a20-4bc8-b7b0-d8c058e34208"
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
                esxcli network vswitch standard portgroup add -p pg-mgmt -v vSwitch0
                esxcli network vswitch standard portgroup set -p pg-mgmt -v 100
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

data "ibm_is_bare_metal_server_initialization" "esxi-host-init" {
  bare_metal_server = ibm_is_bare_metal_server.esxi-host.id
  private_key       = file(var.ssh_private_key)
}

resource "null_resource" "vcenter-provisioner" {
  depends_on = [
    ibm_is_bare_metal_server.esxi-host,
    ibm_is_instance.jump-host,
    null_resource.jump-host-provisioner
  ]
  provisioner "local-exec" {
    interpreter = [
      "/usr/bin/bash", "-c"
    ]
    working_dir = "./external/provisioners/vcenter-provision"
    command = "ansible-playbook -t vcenter-deploy --extra-vars 'esxi_host_password=${data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password} vcenter_ip_address=${ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address}' -i ${ibm_is_floating_ip.jump-host-fip.address}, -u root main.yaml"
  }
}
