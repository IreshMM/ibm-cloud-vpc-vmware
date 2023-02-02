module "common" {
  source = "./modules/common"
  zone               = var.zone
  region             = var.region
  default_vpc_prefix = var.default_vpc_prefix
  ssh_key_name       = var.ssh_key_name
  jump_host_os_image = var.jump_host_os_image
  ssh_public_key     = var.ssh_public_key
}

module "vsphere-site" {
  zone = var.zone
  region = var.region
  source = "./modules/vsphere-site"
  site_name = "primary"
  ssh_private_key = var.ssh_private_key
  ssh_public_key = var.ssh_public_key
  ssh_key_id = module.common.ssh_key_id
  vmware_vpc_id = module.common.vmware_vpc_id
  vmware_vpc_crn = module.common.vmware_vpc_crn
  public_gateway_id = module.common.public_gateway_id
  dns_service_guid = module.common.dns_service_guid
  jump_host_fip = module.common.jump_host_fip
  vmware_vpc_prefix = "10.1.0.0/16"
  apic_subsys_vpc_prefix = "192.168.72.0/24"
  apic_gw_vpc_prefix = "192.168.73.0/24"
}
