# Create compute resources
module "compute" {
  source = "./modules/compute"
  prefix = var.prefix
  ssh_connection = var.ssh_connection
  vsphere_connection = var.vsphere_connection
  vm_count = var.vm_count
  vm_hardware_settings = var.vm_hardware_settings
  vm_network_settings = var.vm_network_settings
  vsphere_settings = var.vsphere_settings
}