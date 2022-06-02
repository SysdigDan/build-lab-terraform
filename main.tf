# Create compute resources
module "compute" {
  source              = "./modules/compute"
  vsphere_user        = var.vsphere_user
  vsphere_password    = var.vsphere_password
  vsphere_server      = var.vsphere_server
  vm_name_prefix      = var.vm_name_prefix
}