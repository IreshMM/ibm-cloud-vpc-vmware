variable "zone" {
  description = "IBM Cloud zone"
}

variable "region" {
  description = "IBM Cloud region"
}

variable "site_name" {
  default = "primary"
}

variable "ssh_private_key" {
  description = "SSH private key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "SSH public key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa.pub"
}

variable "esxi_os_image" {
  description = "OS image used for the esxi bare metal server"
  default = "ibm-esxi-7-0u3g-20328353-byol-amd64-1"
}

variable "ssh_key_id" {
  description = "ID of the existing SSH key"
}

variable "vmware_vpc_id" {
  description = "ID of the VPC to create resources in"
}

variable "vmware_vpc_crn" {
  description = "CRN of the VPC to create resources in"
}

variable "vmware_vpc_prefix" {
  default = "10.1.0.0/16"
}

variable "apic_subsys_vpc_prefix" {
  default = "192.168.72.0/24"
}

variable "apic_gw_vpc_prefix" {
  default = "192.168.73.0/24"
}

variable "public_gateway_id" { }

variable "dns_service_guid" { }

variable "jump_host_fip" { }