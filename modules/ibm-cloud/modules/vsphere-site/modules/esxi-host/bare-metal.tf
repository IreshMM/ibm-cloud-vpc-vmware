resource "ibm_is_bare_metal_server" "esxi-host" {
  profile = var.bare_metal_profile
  name    = var.esxi_host_hostname
  image   = var.esxi_os_image
  zone    = var.zone
  keys    = [var.ssh_key_id]
  primary_network_interface {
    name   = "pci-nic-vmnic0-vmk0"
    subnet = var.host_subnet_id
    primary_ip {
      address     = var.esxi_host_ip
      auto_delete = true
    }
    allowed_vlans = [100, 200, 300, 400, 1200, 1300, 1400]
  }
  vpc       = var.vmware_vpc_id
  user_data = <<EOT
                # enable & start SSH
                vim-cmd hostsvc/enable_ssh
                vim-cmd hostsvc/start_ssh
                # enable & start ESXi Shell
                vim-cmd hostsvc/enable_esx_shell
                vim-cmd hostsvc/start_esx_shell
                # Attempting to set the hostname
                esxcli system hostname set --fqdn=${local.esxi_host_fqdn}
                ${var.vcenter_deploy ? <<EOL
                esxcli network vswitch standard portgroup add -p pg-mgmt -v vSwitch0
                esxcli network vswitch standard portgroup set -p pg-mgmt -v 100
                EOL
                : "" }
                EOT
}

resource "ibm_is_bare_metal_server_network_interface" "vcenter-nic" {
  count = var.vcenter_deploy ? 1 : 0
  bare_metal_server         = ibm_is_bare_metal_server.esxi-host.id
  allow_interface_to_float  = false
  allow_ip_spoofing         = false
  enable_infrastructure_nat = true
  name                      = "vlan-nic-vcenter"
  subnet                    = var.mgmt_subnet_id
  vlan                      = 100
  primary_ip {
    address     = var.vcenter_nic_ip
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "vmotion-nic" {
  bare_metal_server         = ibm_is_bare_metal_server.esxi-host.id
  allow_interface_to_float  = false
  allow_ip_spoofing         = false
  enable_infrastructure_nat = true
  name                      = "vlan-nic-vmotion-vmk2"
  subnet                    = var.vmot_subnet_id
  vlan                      = 200
  primary_ip {
    address     = var.vmot_nic_ip
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "vsan-nic" {
  bare_metal_server         = ibm_is_bare_metal_server.esxi-host.id
  allow_interface_to_float  = false
  allow_ip_spoofing         = false
  enable_infrastructure_nat = true
  name                      = "vlan-nic-vsan-vmk3"
  subnet                    = var.vsan_subnet_id
  vlan                      = 300
  primary_ip {
    address     = var.vsan_nic_ip
    auto_delete = true
  }
}

resource "null_resource" "vcenter-provisioner" {
  count = var.vcenter_deploy ? 1 : 0
  depends_on = [
    ibm_is_bare_metal_server.esxi-host,
  ]
  provisioner "local-exec" {
    interpreter = [
      "/usr/bin/bash", "-c"
    ]
    working_dir = "${path.module}/external/provisioners/vcenter-provision"
    command     = <<EOT
      ansible-playbook -t vcenter-deploy --extra-vars \
        'esxi_host_password=${local.esxi_host_password} \ 
         esxi_host_fqdn=${local.esxi_host_fqdn} \
         vcenter_ip_address=${var.vcenter_nic_ip} \
         vcenter_fqdn=${local.vcenter_fqdn} \
         vcenter_domain=${var.esxi_host_domain} \
         gateway=${var.vcenter_nic_gateway} \
         network_prefix=${var.vcenter_network_prefix}' \
        -i ${var.jump_host_fip}, -u root main.yaml
    EOT
  }
}

data "ibm_is_bare_metal_server_initialization" "esxi-host-init" {
  bare_metal_server = ibm_is_bare_metal_server.esxi-host.id
  private_key       = file(var.ssh_private_key)
}