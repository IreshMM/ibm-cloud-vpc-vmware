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
                      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC64dK7V6GBPV77TzGbsMlEKvZh0earMCCYL7lSseqpLECLVHrO7AjdDjM8jMGezPD4sHGAJN105ZZdu887M4+7KufuUF/CooVJ3e7iH/aL98LZBXxgbsebxvPJael2MULXO6koK26QHrY9FwtVjc1BQWG7MbCaCH3CjhNa+nefEaBhGj+0jnd2eDZjUCTMzFt/H50Ref9tRcAiQCwG9KBJVKMrhiSrjiKcfowVFNbvBunlLFb0Gy79UHP4AVHMl3burUS9cZlU092lBvY+oyTZrKucgm8lGB+d8t9uiMfGGv9uYmka20hPd672N+qa/PdwESXFkd9QoOVkVp3FpqA40TNyeW0DKIk4BOnn3xVzgs0SXyXqF7W8a4rltR0GTqvQ93FC6kdTwlQUhXEjXdUMM/zNJRXALV0Dw/av4QgON18a4UoU2Xd8jxBsQDf7ENlWXdfavFn6KhI/iY3IaOyezfnzlj5qbQBLom7nqFJj1YZW1C6rK51oCf9q2bQPrF0= iresh@iresh-pc
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
