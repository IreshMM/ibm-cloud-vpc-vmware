resource "ibm_is_vpc_address_prefix" "vmware-vpc-prefix" {
  name = "vmware-vpc-prefix-${var.site_name}"
  zone = var.zone
  vpc  = var.vmware_vpc_id
  cidr = var.vmware_vpc_prefix
}

locals {
  network_bits = 3
  subnets = {
    vmw-host-mgmt-subnet = 0
    vmw-inst-mgmt-subnet = 1
    vmw-vmot-subnet      = 2 # TODO allow float
    vmw-vsan-subnet      = 4
  }
}

resource "ibm_is_subnet" "vmw-infr-subnets" {
  depends_on = [
    ibm_is_vpc_address_prefix.vmware-vpc-prefix
  ]
  for_each        = local.subnets
  name            = "${each.key}-${var.site_name}"
  vpc             = var.vmware_vpc_id
  zone            = var.zone
  ipv4_cidr_block = cidrsubnet(var.vmware_vpc_prefix, local.network_bits, each.value)
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-internet-outbound-gw-attachment" {
  subnet         = ibm_is_subnet.vmw-infr-subnets["vmw-inst-mgmt-subnet"].id
  public_gateway = var.public_gateway_id
}