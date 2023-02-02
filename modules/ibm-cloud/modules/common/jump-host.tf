resource "ibm_is_instance" "jump-host" {
  name    = "jump-host"
  image   = data.ibm_is_image.jump-host-os-image.id
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.default-vpc-subnet.id
  }

  vpc            = ibm_is_vpc.vmw-apic.id
  keys           = [data.ibm_is_ssh_key.iresh-pc.id]
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
  zone = var.zone
}

data "ibm_is_image" "jump-host-os-image" {
  name = var.jump_host_os_image
}

resource "ibm_is_floating_ip" "jump-host-fip" {
  name   = "jump-host-fip"
  target = ibm_is_instance.jump-host.primary_network_interface[0].id
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

resource "null_resource" "jump-host-provisioner" {
  depends_on = [
    ibm_is_instance.jump-host,
    ibm_is_floating_ip.jump-host-fip
  ]
  provisioner "local-exec" {
    interpreter = [
      "/usr/bin/bash", "-c"
    ]
    working_dir = "${path.module}/external/provisioners/jump-host-provision"
    command     = "ansible-playbook -i ${ibm_is_floating_ip.jump-host-fip.address}, -u root site.yaml"
  }
}
