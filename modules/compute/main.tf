variable "offset" {
  default = 1
}
variable "start_ipv4_address" {
  default = 100
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "LAB"
}

data "vsphere_datastore" "datastore" {
  name          = "LAB-VM-01"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "RESOURCES"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "lab_management_6"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-20.04.2"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count            = 1
  name             = "${var.vm_name_prefix}${format("%02d-worker-", count.index + 1 + var.offset)}"
  folder           = "Terraform"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  firmware         = "${data.vsphere_virtual_machine.template.firmware}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.vm_name_prefix}${format("%02d-worker-", count.index + 1 + var.offset)}"
        domain    = "prod.com"
      }
	  network_interface {
        ipv4_address = "${format("192.168.6.%d", (count.index + 1 + var.offset + var.start_ipv4_address))}"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "192.168.6.254"
	    dns_suffix_list = ["lab.internal"]
      dns_server_list = ["192.168.6.254"]
    }
  }
}