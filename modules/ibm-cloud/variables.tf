variable "ssh_private_key" {
  description = "SSH private key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "SSH public key to be used for authenticating to resources"
  default     = "~/.ssh/id_rsa.pub"
}

variable "zone" {
  description = "IBM Cloud zone"
}

variable "region" {
  description = "IBM Cloud region"
}
