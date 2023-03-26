locals {
  esxi_host_password = data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password
  esxi_host_fqdn     = "${var.esxi_host_hostname}.${var.esxi_host_domain}"
  vcenter_fqdn       = "vcenter.${var.esxi_host_domain}"
}