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
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
    name          = "RESOURCES"
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "lab_management_6"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-20.04.2"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  folder           = "Terraform"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  # disk {
  #     label            = "disk0"
  #     size             = data.vsphere_virtual_machine.template.disks.0.size
  #     thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  # }
  # network_interface {
  #     network_id   = data.vsphere_network.network.id
  #     adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  # }
}