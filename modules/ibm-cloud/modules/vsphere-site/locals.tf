locals {
  esxi_host_info = [
    for i in range(var.esxi_host_count): {
      esxi_host_hostname = "esx-${i}"
      host_subnet_id     = ibm_is_subnet.vmw-infr-subnets["vmw-host-mgmt-subnet"].id
      esxi_host_ip       = cidrhost(ibm_is_subnet.vmw-infr-subnets["vmw-host-mgmt-subnet"].ipv4_cidr_block, i + 10)
      vmot_subnet_id     = ibm_is_subnet.vmw-infr-subnets["vmw-vmot-subnet"].id
      vmot_nic_ip        = cidrhost(ibm_is_subnet.vmw-infr-subnets["vmw-vmot-subnet"].ipv4_cidr_block, i + 10)
      vsan_subnet_id     = ibm_is_subnet.vmw-infr-subnets["vmw-vsan-subnet"].id
      vsan_nic_ip        = cidrhost(ibm_is_subnet.vmw-infr-subnets["vmw-vsan-subnet"].ipv4_cidr_block, i + 10)
      mgmt_subnet_id     = ibm_is_subnet.vmw-infr-subnets["vmw-inst-mgmt-subnet"].id
      vcenter_nic_ip     = cidrhost(ibm_is_subnet.vmw-infr-subnets["vmw-inst-mgmt-subnet"].ipv4_cidr_block, 10)
      vcenter_nic_gateway = cidrhost(ibm_is_subnet.vmw-infr-subnets["vmw-inst-mgmt-subnet"].ipv4_cidr_block, 1)
      vcenter_network_prefix = split("/", ibm_is_subnet.vmw-infr-subnets["vmw-inst-mgmt-subnet"].ipv4_cidr_block)[1]
    }
  ]
}
