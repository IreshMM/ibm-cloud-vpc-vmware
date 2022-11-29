resource "ibm_is_vpc" "vmw" {
  resource_group = ibm_resource_group.VMware.id
  name           = "vmw"
}

resource "ibm_is_vpc_address_prefix" "vmware-vpc-prefix" {
  name = "vmware-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw.id
  cidr = "10.1.0.0/16"
}

resource "ibm_is_vpc_address_prefix" "apic-subsys-vpc-prefix" {
  name = "apic-subsys-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw.id
  cidr = "192.168.72.0/24"
}

resource "ibm_is_vpc_address_prefix" "apic-gw-vpc-prefix" {
  name = "apic-gw-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw.id
  cidr = "172.22.10.0/24"
}

resource "ibm_is_subnet" "vmw-host-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-host-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.1.1.0/24"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-mgmt-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-mgmt-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.1.2.0/24"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-subsys-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-subsys-vpc-prefix]
  name            = "vmw-apic-subsys-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "192.168.72.0/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-gw-frontend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-frontend-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "172.22.10.0/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-gw-backend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-backend-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "172.22.10.128/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_public_gateway" "vmware-internet-outbound" {
  name = "vmware-internet-outbound"
  vpc  = ibm_is_vpc.vmw.id
  zone = var.zone
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment" {
  subnet         = ibm_is_subnet.vmw-mgmt-subnet.id
  public_gateway = ibm_is_public_gateway.vmware-internet-outbound.id
}

resource "ibm_is_ssh_key" "iresh-pc" {
  name       = "iresh-pc"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC64dK7V6GBPV77TzGbsMlEKvZh0earMCCYL7lSseqpLECLVHrO7AjdDjM8jMGezPD4sHGAJN105ZZdu887M4+7KufuUF/CooVJ3e7iH/aL98LZBXxgbsebxvPJael2MULXO6koK26QHrY9FwtVjc1BQWG7MbCaCH3CjhNa+nefEaBhGj+0jnd2eDZjUCTMzFt/H50Ref9tRcAiQCwG9KBJVKMrhiSrjiKcfowVFNbvBunlLFb0Gy79UHP4AVHMl3burUS9cZlU092lBvY+oyTZrKucgm8lGB+d8t9uiMfGGv9uYmka20hPd672N+qa/PdwESXFkd9QoOVkVp3FpqA40TNyeW0DKIk4BOnn3xVzgs0SXyXqF7W8a4rltR0GTqvQ93FC6kdTwlQUhXEjXdUMM/zNJRXALV0Dw/av4QgON18a4UoU2Xd8jxBsQDf7ENlWXdfavFn6KhI/iY3IaOyezfnzlj5qbQBLom7nqFJj1YZW1C6rK51oCf9q2bQPrF0= iresh@iresh-pc"
  resource_group  = ibm_resource_group.VMware.id
}
