resource "ibm_is_vpc" "vmw" {
  resource_group = ibm_resource_group.VMware.id
  name = "vmw"
}

resource "ibm_is_vpc_address_prefix" "vmware-vpc-prefix" {
  name = "vmware-vpc-prefix"
  zone = var.zone
  vpc  = ibm_is_vpc.vmw.id
  cidr = "10.97.0.0/22"
}

resource "ibm_is_subnet" "vmw-host-mgmt-subnet" {
  depends_on = [ ibm_is_vpc_address_prefix.vmware-vpc-prefix ]
  name            = "vmw-host-mgmt-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.97.0.0/25"
}

resource "ibm_is_subnet" "vmw-inst-mgmt-subnet" {
  depends_on = [ ibm_is_vpc_address_prefix.vmware-vpc-prefix ]
  name            = "vmw-host-inst-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.97.0.128/25"
}

resource "ibm_is_subnet" "vmw-vmot-subnet" {
  depends_on = [ ibm_is_vpc_address_prefix.vmware-vpc-prefix ]
  name            = "vmw-vmot-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.97.1.0/25"
}

resource "ibm_is_subnet" "vmw-vsan-subnet" {
  depends_on = [ ibm_is_vpc_address_prefix.vmware-vpc-prefix ]
  name            = "vmw-vsan-subnet"
  vpc             = ibm_is_vpc.vmw.id
  zone            = var.zone
  ipv4_cidr_block = "10.97.2.0/25"
}

resource "ibm_is_public_gateway" "vmware-mgmt-internet-outbound" {
  name = "vmware-mgmt-internet-outbound"
  vpc  = ibm_is_vpc.vmw.id
  zone = var.zone
}

resource "ibm_is_subnet_public_gateway_attachment" "vmware-mgmt-internet-outbound-gw-attachment" {
  subnet                = ibm_is_subnet.vmw-inst-mgmt-subnet.id
  public_gateway         = ibm_is_public_gateway.vmware-mgmt-internet-outbound.id
}

resource "ibm_is_ssh_key" "cloud-workstation-1" {
  name       = "cloud-workstation-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDn/kKHVZdz8VHzw6U2evrvgGlUXqVKiN5DABTfDHF7BNq8YIOJRuo31u3LxMLaZvzaWvIC1GFoHWkWsR8cf/KQ1AZ65Z74erBolGTQ0HhxscSTEe3j/RMeWZLsGfb945nmjV1d+jc1iuVqsm+wMQ5oPsIK/UWqhyP/hG3v9LPE11QJaw/GCa2WKyveLavirh7kcOPawwwGf2WDmf2wCn5xHoKY57wlkY9QfY2WTsq+kQ2JhSyHm5Kn+aWKOw0h5gCWfD5Owq3CcUdtzXO30us5xHIi3AlJ9u3lGZdI4+ium76wTQqZaa+lZY0/xDDk4LesqgQCYFlIMpOd5yym4P0kiTdQms3Y47HUZa/iDsGSh8RFuYN86fcJHLODhzZzJrFkjGd/Hg8hbRupnpsF5kay0AiNr6zE/sSIg7rsCjiv/SbPnGtpF72m3Vg8jFCJcsigsYhFrBwAIALkNrmwgxoXgJa0lxkLzQoyhQ5hQgKG8/JpHyensQHjHsAetiYYSAwlV+qXP0ANty9IH9Y7e21utebUpSEAg5Mlgwm70ERPkZTgJ5H6FYxrMaUkCjZaIMBJ+WNjjyVq7uduGb0F/qWA88xl1vz7eGRDHqXkNx3qDxhHkh+55/6/GnvlhtdNDKM6+nOQ+iQnj6M4Y2Y50oLsHUVJQxc4y7HayO9fvDYdw== iresh"
}