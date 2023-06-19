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

variable "bare_metal_profile" {
  default = "cx2d-metal-96x192"
}

variable "esxi_host_count" {
  description = "The number esxi hosts"
  default = 1
}

variable "esxi_os_image" {
  description = "OS image used for the esxi bare metal server"
  default = "r006-41460465-7a20-4bc8-b7b0-d8c058e34208"
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
  description = "Network prefix of the VPC for creating subnets in"
}

variable "public_gateway_id" { }

variable "dns_service_guid" { }

variable "jump_host_fip" { }