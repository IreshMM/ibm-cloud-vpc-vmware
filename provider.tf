provider "ibm" {
  region                = var.region
  zone                  = var.zone
  ibmcloud_api_key      = var.ibmcloud_api_key
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key  = var.iaas_classic_api_key
}

provider "ibm" {
  alias                 = "ibmcloud"
  region                = var.region
  zone                  = var.zone
  ibmcloud_api_key      = var.ibmcloud_api_key
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key  = var.iaas_classic_api_key
  resource_group        = ibm_resource_group.VMware.id
}

provider "vsphere" {
  alias                = "vsphere"
  user                 = "administrator@${module.ibm-cloud-infr.vcenter_domain}"
  password             = var.vsphere_password
  vsphere_server       = module.ibm-cloud-infr.vcenter_fqdn
  allow_unverified_ssl = true
}

variable "ibmcloud_api_key" {
  type = string
}

variable "iaas_classic_username" {
  type = string
}

variable "iaas_classic_api_key" {
  type = string
}

variable "vsphere_user" {
  type    = string
  default = "administrator@vmware.ibmcloud.local"
}

variable "vsphere_password" {
  type    = string
}

variable "vsphere_server" {
  type    = string
  default = "vcenter.vmware.ibmcloud.local:4443"
}