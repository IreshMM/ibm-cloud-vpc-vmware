module "esxi-host" {
  count  = var.esxi_host_count
  source = "./modules/esxi-host"

  depends_on = [
    ibm_dns_resource_record.esxi-host-records,
    ibm_dns_resource_record.vcenter-record
  ]

  region                 = var.region
  zone                   = var.zone
  site_name              = var.site_name
  ssh_private_key        = var.ssh_private_key
  bare_metal_profile     = var.bare_metal_profile
  esxi_os_image          = var.esxi_os_image
  esxi_host_hostname     = local.esxi_host_info[count.index].esxi_host_hostname
  esxi_host_domain       = ibm_dns_zone.vmware-site-dns-zone.name
  host_subnet_id         = local.esxi_host_info[count.index].host_subnet_id
  esxi_host_ip           = local.esxi_host_info[count.index].esxi_host_ip
  vmot_subnet_id         = local.esxi_host_info[count.index].vmot_subnet_id
  vmot_nic_ip            = local.esxi_host_info[count.index].vmot_nic_ip
  vsan_subnet_id         = local.esxi_host_info[count.index].vsan_subnet_id
  vsan_nic_ip            = local.esxi_host_info[count.index].vsan_nic_ip
  mgmt_subnet_id         = local.esxi_host_info[count.index].mgmt_subnet_id
  vcenter_nic_ip         = local.esxi_host_info[count.index].vcenter_nic_ip
  vcenter_nic_gateway    = local.esxi_host_info[count.index].vcenter_nic_gateway
  vcenter_network_prefix = local.esxi_host_info[count.index].vcenter_network_prefix
  vcenter_deploy         = count.index == 0
  ssh_key_id             = var.ssh_key_id
  vmware_vpc_id          = var.vmware_vpc_id
  jump_host_fip          = var.jump_host_fip
}
