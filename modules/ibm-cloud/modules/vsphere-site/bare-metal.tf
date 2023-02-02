resource "ibm_is_bare_metal_server" "esxi-host" {
  profile = "cx2-metal-96x192"
  name    = "esxi-host0-${var.site_name}"
  image   = data.ibm_is_image.esxi-os-image.id
  zone    = var.zone
  keys    = [var.ssh_key_id]
  primary_network_interface {
    name   = "pci-nic-vmnic0-vmk0"
    subnet = ibm_is_subnet.vmw-host-subnet.id
    primary_ip {
      address     = cidrhost(ibm_is_subnet.vmw-host-subnet.ipv4_cidr_block, 10)
      auto_delete = true
    }
    allowed_vlans = [100, 200, 300, 400]
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
                esxcli system hostname set --fqdn=esxi-host0.${var.site_name}.vmware.ibmcloud.local
                esxcli network vswitch standard portgroup add -p pg-mgmt -v vSwitch0
                esxcli network vswitch standard portgroup set -p pg-mgmt -v 100
                EOT
}

data "ibm_is_image" "esxi-os-image" {
  name = var.esxi_os_image
}

resource "ibm_is_bare_metal_server_network_interface" "vcenter-nic" {
  bare_metal_server         = ibm_is_bare_metal_server.esxi-host.id
  allow_interface_to_float  = false
  allow_ip_spoofing         = false
  enable_infrastructure_nat = true
  name                      = "vmware-vcenter-nic-${var.site_name}"
  subnet                    = ibm_is_subnet.vmw-mgmt-subnet.id
  vlan                      = 100
  primary_ip {
    address     = cidrhost(ibm_is_subnet.vmw-mgmt-subnet.ipv4_cidr_block, 10)
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "apic-subsys-nics" {
  for_each = {
    apic-mgr    = cidrhost(ibm_is_subnet.vmw-apic-subsys-subnet.ipv4_cidr_block, 11)
    apic-anytcs = cidrhost(ibm_is_subnet.vmw-apic-subsys-subnet.ipv4_cidr_block, 12)
    apic-devptl = cidrhost(ibm_is_subnet.vmw-apic-subsys-subnet.ipv4_cidr_block, 13)
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-subsys-subnet.id
  name                     = "${each.key}-${var.site_name}"
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
    apic-dpgw1-fe = cidrhost(ibm_is_subnet.vmw-apic-gw-frontend-subnet.ipv4_cidr_block, 11)
    apic-dpgw2-fe = cidrhost(ibm_is_subnet.vmw-apic-gw-frontend-subnet.ipv4_cidr_block, 12)
    apic-dpgw3-fe = cidrhost(ibm_is_subnet.vmw-apic-gw-frontend-subnet.ipv4_cidr_block, 13)
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-gw-frontend-subnet.id
  name                     = "${each.key}-${var.site_name}"
  vlan                     = 300
  allow_interface_to_float = false
  primary_ip {
    address     = each.value
    auto_delete = true
  }
}

resource "ibm_is_bare_metal_server_network_interface" "apic-gw-backend-nics" {
  for_each = {
    apic-dpgw1-be = cidrhost(ibm_is_subnet.vmw-apic-gw-backend-subnet.ipv4_cidr_block, 11)
    apic-dpgw2-be = cidrhost(ibm_is_subnet.vmw-apic-gw-backend-subnet.ipv4_cidr_block, 12)
    apic-dpgw3-be = cidrhost(ibm_is_subnet.vmw-apic-gw-backend-subnet.ipv4_cidr_block, 13)
  }
  bare_metal_server        = ibm_is_bare_metal_server.esxi-host.id
  subnet                   = ibm_is_subnet.vmw-apic-gw-backend-subnet.id
  name                     = "${each.key}-${var.site_name}"
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

locals {
  esxi_host_password = data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password
  esxi_host_fqdn     = ibm_dns_resource_record.esxi-host-record.name
  vcenter_ip_address = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
  vcenter_fqdn       = ibm_dns_resource_record.vcenter-record.name
  vcenter_domain     = ibm_dns_zone.vmware-site-dns-zone.name
}

resource "null_resource" "vcenter-provisioner" {
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
         vcenter_ip_address=${local.vcenter_ip_address} \
         vcenter_fqdn=${local.vcenter_fqdn} \
         vcenter_domain=${local.vcenter_domain}' \
        -i ${var.jump_host_fip}, -u root main.yaml
    EOT
  }
}
