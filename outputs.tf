output "jump-host-fip" {
    value = ibm_is_floating_ip.jump-host-fip.address
}

output "vcenter-ip" {
    value = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
}