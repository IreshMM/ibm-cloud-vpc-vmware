resource "ibm_resource_group" "VMware" {
  name = "VMware"
}

module "ibm-cloud-infr" {
  providers = {
    ibm = ibm.ibmcloud
  }
  source = "./modules/ibm-cloud"
}

module "vmware-vcenter-infr" {
  providers = {
    vsphere = vsphere.vsphere
  }
  depends_on = [module.ibm-cloud-infr]
  source     = "./modules/vmware-vcenter"

  zone                  = var.zone
  region                = var.region
  vsphere_host_password = module.ibm-cloud-infr.esxi_host_password
  vsphere_host_fqdn     = module.ibm-cloud-infr.esxi_host_fqdn
}
