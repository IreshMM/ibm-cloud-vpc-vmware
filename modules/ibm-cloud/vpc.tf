resource "ibm_is_vpc" "vmw-apic" {
  resource_group = ibm_resource_group.VMware.id
  name           = "vmw-apic"
}

resource "ibm_is_vpc_address_prefix" "vmware-vpc-prefix" {
  name = "vmware-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw-apic.id
  cidr = "10.1.0.0/16"
}

resource "ibm_is_vpc_address_prefix" "apic-subsys-vpc-prefix" {
  name = "apic-subsys-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw-apic.id
  cidr = "192.168.72.0/24"
}

resource "ibm_is_vpc_address_prefix" "apic-gw-vpc-prefix" {
  name = "apic-gw-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw-apic.id
  cidr = "192.168.73.0/24"
}

resource "ibm_is_subnet" "vmw-host-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-host-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  zone            = var.zone
  ipv4_cidr_block = "10.1.1.0/24"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-mgmt-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vmware-vpc-prefix]
  name            = "vmw-mgmt-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  zone            = var.zone
  ipv4_cidr_block = "10.1.2.0/24"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-subsys-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-subsys-vpc-prefix]
  name            = "vmw-apic-subsys-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  zone            = var.zone
  ipv4_cidr_block = "192.168.72.0/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-gw-frontend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-frontend-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  zone            = var.zone
  ipv4_cidr_block = "192.168.73.0/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet" "vmw-apic-gw-backend-subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.apic-gw-vpc-prefix]
  name            = "vmw-apic-gw-backend-subnet"
  vpc             = ibm_is_vpc.vmw-apic.id
  zone            = var.zone
  ipv4_cidr_block = "192.168.73.128/25"
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_public_gateway" "vmware-internet-outbound" {
  name = "vmware-internet-outbound"
  vpc  = ibm_is_vpc.vmw-apic.id
  zone = var.zone
  resource_group  = ibm_resource_group.VMware.id
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment" {
  subnet         = ibm_is_subnet.vmw-mgmt-subnet.id
  public_gateway = ibm_is_public_gateway.vmware-internet-outbound.id
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment-subsys-subnet" {
  subnet         = ibm_is_subnet.vmw-apic-subsys-subnet.id
  public_gateway = ibm_is_public_gateway.vmware-internet-outbound.id
}

data "ibm_is_ssh_key" "iresh-pc" {
  name       = "iresh-pc"
}