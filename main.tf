resource "ibm_resource_group" "VMware" {
  name = "VMware"
}

module "ibm-cloud-infr" {
  providers = {
    ibm = ibm.ibmcloud
  }
  source = "./modules/ibm-cloud"
  ssh_public_key = var.ssh_public_key
}

module "vmware-vcenter-infr" {
  providers = {
    vsphere = vsphere.vsphere
  }
  depends_on = [module.ibm-cloud-infr]
  source     = "./modules/vmware-vcenter"

  zone                  = var.zone
  region                = var.region
  vsphere_host_passwords = module.ibm-cloud-infr.esxi_host_passwords
  vsphere_host_fqdns     = module.ibm-cloud-infr.esxi_host_fqdns
}