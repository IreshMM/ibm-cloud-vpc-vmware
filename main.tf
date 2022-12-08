module "ibm-cloud-infr" {
  providers = {
    ibm = ibm.ibmcloud
  }
  zone = var.zone
  region = var.region
  source = "./modules/ibm-cloud"
}

module "vmware-vcenter-infr" {
  providers = {
    vsphere = vsphere.vsphere
  }

  depends_on            = [module.ibm-cloud-infr]
  source                = "./modules/vmware-vcenter"
  vsphere_host_password = module.ibm-cloud-infr.esxi-host-password
}
