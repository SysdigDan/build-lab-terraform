variable "vsphere_user" {
  description = "vSphere username used to provision virtual machine"
  type = string
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  description = "vSphere username password"
  type = string
}
variable "vsphere_server" {
  description = "vSphere server IP ro FQDN"
  type = string
}

variable "vm_name_prefix" {
  description = "Virtual machine name prefix"
  type = string
}

variable "vm_worker_count" {
  description = "Virtual machine name prefix"
  type = string
  default = "3"
}