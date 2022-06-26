provider "ibm" {
  region                = "eu-de"
  zone                  = "eu-de-1"
  ibmcloud_api_key      = var.ibmcloud_api_key
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key  = var.iaas_classic_api_key
}

resource "ibm_resource_group" "VMware" {
  name = "VMware"
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
