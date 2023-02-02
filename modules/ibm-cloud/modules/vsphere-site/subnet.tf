resource "ibm_is_vpc_address_prefix" "vmware-vpc-prefix" {
  name = "vmware-vpc-prefix-${var.site_name}"
  zone = var.zone
  vpc  = var.vmware_vpc_id
  cidr = var.vmware_vpc_prefix
}

resource "ibm_is_vpc_address_prefix" "apic-subsys-vpc-prefix" {
  name = "apic-subsys-vpc-prefix-${var.site_name}"
  zone = var.zone
  vpc  = var.vmware_vpc_id
  cidr = var.apic_subsys_vpc_prefix
}

resource "ibm_is_vpc_address_prefix" "apic-gw-vpc-prefix" {
  name = "apic-gw-vpc-prefix-${var.site_name}"
  zone = var.zone
  vpc  = var.vmware_vpc_id
  cidr = var.apic_gw_vpc_prefix
}

resource "ibm_is_subnet" "vmw-host-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-host-subnet-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.vmware_vpc_prefix, 8, 1)
}

resource "ibm_is_subnet" "vmw-mgmt-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-mgmt-subnet-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.vmware_vpc_prefix, 8, 2)
}

resource "ibm_is_subnet" "vmw-apic-subsys-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-subsys-vpc-prefix]
  name            = "vmw-apic-subsys-subnet-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.apic_subsys_vpc_prefix, 1, 0)
}

resource "ibm_is_subnet" "vmw-apic-gw-frontend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-frontend-subnet-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.apic_gw_vpc_prefix, 1, 0)
}

resource "ibm_is_subnet" "vmw-apic-gw-backend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-backend-subnet-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.apic_gw_vpc_prefix, 1, 1)
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment" {
  subnet         = ibm_is_subnet.vmw-mgmt-subnet.id
  public_gateway = var.public_gateway_id
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment-subsys-subnet" {
  subnet         = ibm_is_subnet.vmw-apic-subsys-subnet.id
  public_gateway = var.public_gateway_id
}