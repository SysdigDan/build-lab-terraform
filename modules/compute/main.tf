provider "vsphere" {
  vsphere_server = "${var.vsphere_connection.vsphere_server}"
  user           = "${var.vsphere_connection.vsphere_user}"
  password       = "${var.vsphere_connection.vsphere_password}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

# Create controller nodes
resource "vsphere_virtual_machine" "controllers" {
  count            = "${var.vm_count.controllers}"
  name             = "${var.prefix}-controller-${format("%02d", count.index + 1)}"
  folder           = "${var.vsphere_connection.vsphere_vm_folder}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  firmware         = "${data.vsphere_virtual_machine.template.firmware}"

  num_cpus = "${var.vm_hardware_settings.cpu}"
  memory   = "${var.vm_hardware_settings.mem}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    # eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.prefix}-controller-${format("%02d", count.index + 1)}"
        domain    = "${var.vm_network_settings.dns_domain}"
      }
	  network_interface {
        ipv4_address = cidrhost(var.vm_network_settings.ipv4_cidr, (count.index + 1 + var.vm_network_settings.start_ipv4_address))
        ipv4_netmask = "${var.vm_network_settings.ipv4_netmask}"
      }
      ipv4_gateway = "${var.vm_network_settings.ipv4_gateway}"
	    dns_suffix_list = ["${var.vm_network_settings.dns_domain}"]
      dns_server_list = "${var.vm_network_settings.dns_server_list}"
    }
  }

  connection {
    type     = "ssh"
    user     = "${var.ssh_connection.ssh_user}"
    password = "${var.ssh_connection.ssh_password}"
    host     = self.default_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "curl -s https://raw.githubusercontent.com/SysdigDan/scripts/master/prepare-k8s-crio.sh --output /tmp/prepare-k8s-crio.sh",
      "chmod +x /tmp/prepare-k8s-crio.sh && /tmp/prepare-k8s-crio.sh > /tmp/prepare-k8s-crio.log"
    ]
  }
}

# Create worker nodes
resource "vsphere_virtual_machine" "workers" {
  count            = "${var.vm_count.workers}"
  name             = "${var.prefix}-worker-${format("%02d", count.index + 1)}"
  folder           = "${var.vsphere_connection.vsphere_vm_folder}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  firmware         = "${data.vsphere_virtual_machine.template.firmware}"

  num_cpus = "${var.vm_hardware_settings.cpu}"
  memory   = "${var.vm_hardware_settings.mem}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    # eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.prefix}-worker-${format("%02d", count.index + 1)}"
        domain    = "${var.vm_network_settings.dns_domain}"
      }
	  network_interface {
        ipv4_address = cidrhost(var.vm_network_settings.ipv4_cidr, (count.index + 1 + var.vm_count.controllers + var.vm_network_settings.start_ipv4_address))
        ipv4_netmask = "${var.vm_network_settings.ipv4_netmask}"
      }
      ipv4_gateway = "${var.vm_network_settings.ipv4_gateway}"
	    dns_suffix_list = ["${var.vm_network_settings.dns_domain}"]
      dns_server_list = "${var.vm_network_settings.dns_server_list}"
    }
  }

  connection {
    type     = "ssh"
    user     = "${var.ssh_connection.ssh_user}"
    password = "${var.ssh_connection.ssh_password}"
    host     = self.default_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "curl -s https://raw.githubusercontent.com/SysdigDan/scripts/master/prepare-k8s-crio.sh --output /tmp/prepare-k8s-crio.sh",
      "chmod +x /tmp/prepare-k8s-crio.sh && /tmp/prepare-k8s-crio.sh > /tmp/prepare-k8s-crio.log"
    ]
  }
}