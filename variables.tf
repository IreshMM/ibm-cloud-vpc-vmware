variable "zone" {
    description = "IBM Cloud zone"
    default = "us-south-1"
}

variable "region" {
  description = "IBM Cloud region"
  default = "us-south"
}

variable "ssh_private_key" {
  description = "SSH private key to be used for authenticating to resources"
  default = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "SSH public key to be used for authenticating to resources"
  default = "~/.ssh/id_rsa.pub"
}