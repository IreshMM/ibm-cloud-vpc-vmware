variable "zone" {
    description = "IBM Cloud zone"
    default = "us-south-1"
}

variable "region" {
  description = "IBM Cloud region"
  default = "us-south"
}

variable "default_vpc_prefix" {
  description = "Prefix for the default VPC subnet"
  type = string
  default = "10.24.0.0/16"
}

variable "ssh_public_key" {
  description = "SSH public key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key" {
  description = "SSH private key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa"
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

variable "esxi_os_image" {
  description = "OS image used for the esxi bare metal server"
  default = "r006-41460465-7a20-4bc8-b7b0-d8c058e34208"
}