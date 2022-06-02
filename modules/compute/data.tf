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