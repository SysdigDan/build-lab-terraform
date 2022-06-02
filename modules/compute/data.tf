data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_settings.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_settings.vsphere_datastore
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_settings.vsphere_cluster
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "network" {
  name          = var.vsphere_settings.vsphere_network
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_settings.vsphere_template
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}