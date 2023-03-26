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

variable "bare_metal_profile" {
  default = "cx2-metal-96x192"
}

variable "esxi_os_image" {
  description = "OS image used for the esxi bare metal server"
  default = "r006-41460465-7a20-4bc8-b7b0-d8c058e34208"
}

variable "host_subnet_id" {
  description = "Host subnet for esxi host"
}

variable "esxi_host_ip" {
  description = "Primary IP address of the esxi host"
}

variable "esxi_host_hostname" {
  description = "Host of the esxi host"
}

variable "esxi_host_domain" {
  description = "Domain of the esxi host"
}

variable "vmot_subnet_id" {
  description = "vMotion subnet for esxi host"
}

variable "vmot_nic_ip" {
  description = "IP address of the vMotion NIC"
}

variable "vsan_subnet_id" {
  description = "vSAN subnet for the esxi host"
}

variable "vsan_nic_ip" {
  description = "IP address of the vSAN NIC"
}

variable "mgmt_subnet_id" {
  description = "Management subnet ID (for vcenter nic)"
}

variable "vcenter_nic_ip" {
  description = "IP address of the vCenter NIC"
}

variable "vcenter_nic_gateway" {
  description = "Gateway of the vCenter NIC"
}

variable "vcenter_network_prefix" {
  description = "Network prefix of the vCenter NIC network"
}

variable "vcenter_deploy" {
  type = bool
  description = "Whether to initially deploy vcenter"
}

variable "ssh_key_id" {
  description = "ID of the existing SSH key"
}

variable "vmware_vpc_id" {
  description = "ID of the VPC to create resources in"
}

variable "jump_host_fip" { }