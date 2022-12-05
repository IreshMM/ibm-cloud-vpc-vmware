resource "ibm_is_instance" "jump-host" {
  name    = "jump-host"
  image   = "r006-b5427052-bf0d-400a-a55c-e70894560b96"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.vmw-mgmt-subnet.id
  }

  vpc            = ibm_is_vpc.vmw-apic.id
  zone           = var.zone
  keys           = [data.ibm_is_ssh_key.iresh-pc.id]
  resource_group = ibm_resource_group.VMware.id
  user_data      = <<EOT
                #cloud-config
                hostname: jump-host
                fqdn: jump-host.vmware.ibmcloud.local
                users:
                  - default
                  - name: iresh
                    gecos: Iresh Dissanayaka
                    groups: wheel
                    shell: /bin/bash
                    plain_text_passwd: admin123
                    lock_passwd: false
                    ssh_authorized_keys:
                      - ${file(var.ssh_public_key)}
                EOT
}

resource "ibm_is_floating_ip" "jump-host-fip" {
  name           = "jump-host-fip"
  target         = ibm_is_instance.jump-host.primary_network_interface[0].id
  resource_group = ibm_resource_group.VMware.id
}

data "ibm_is_instance_network_interface" "jump-host-nic" {
  instance_name          = ibm_is_instance.jump-host.name
  network_interface_name = ibm_is_instance.jump-host.primary_network_interface[0].name
}

resource "ibm_is_security_group_rule" "allow-ssh" {
  group     = data.ibm_is_instance_network_interface.jump-host-nic.security_groups[0].id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}
