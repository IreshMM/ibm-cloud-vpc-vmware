variable "zone" {
    description = "IBM Cloud zone"
    default = "us-south-1"
}

variable "region" {
  description = "IBM Cloud region"
  default = "us-south"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type = string
  default = "vmw-apic"
}

variable "default_vpc_prefix" {
  description = "Prefix for the default VPC subnet"
  type = string
  default = "10.24.0.0/16"
}

variable "ssh_key_name" {
  description = "Name of the existing SSH key"
  type = string
  default = "iresh-pc"
}

variable "jump_host_os_image" {
  description = "Name of the Ubuntu image used for jump-host"
  type = string
  default = "ibm-ubuntu-22-04-minimal-amd64-1"
}

variable "ssh_public_key" {
  description = "SSH public key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa.pub"
}