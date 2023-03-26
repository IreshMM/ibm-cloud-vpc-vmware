resource "ibm_is_vpc" "vmw-apic" {
  name = var.vpc_name
}

resource "ibm_is_vpc_address_prefix" "default-vpc-prefix" {
  name       = "default-vpc-prefix"
  vpc        = ibm_is_vpc.vmw-apic.id
  cidr       = var.default_vpc_prefix
  zone       = var.zone
}

resource "ibm_is_subnet" "default-vpc-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.default-vpc-prefix]
  name            = "default-vpc-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  ipv4_cidr_block = cidrsubnet(var.default_vpc_prefix, 8, 1)
  zone            = var.zone
}

resource "ibm_is_public_gateway" "vmware-internet-outbound" {
  name = "vmware-internet-outbound"
  vpc  = ibm_is_vpc.vmw-apic.id
  zone = var.zone
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment" {
  subnet         = ibm_is_subnet.default-vpc-subnet.id
  public_gateway = ibm_is_public_gateway.vmware-internet-outbound.id
}

data "ibm_is_ssh_key" "iresh-pc" {
  name = var.ssh_key_name
}