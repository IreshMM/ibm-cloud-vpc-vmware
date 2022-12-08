output "jump-host-fip" {
    value = ibm_is_floating_ip.jump-host-fip.address
}

output "vcenter-ip" {
    value = ibm_is_bare_metal_server_network_interface.vcenter-nic.primary_ip[0].address
}

output "esxi-host-password" {
    value = data.ibm_is_bare_metal_server_initialization.esxi-host-init.user_accounts[0].password
    sensitive = true
}