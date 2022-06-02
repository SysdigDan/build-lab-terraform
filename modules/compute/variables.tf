variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "vm_name_prefix" {}

variable "vm_controller_count" {
  description = "Virtual machine name prefix"
  type = string
  default = "1"
}

variable "vm_worker_count" {
  description = "Virtual machine name prefix"
  type = string
  default = "3"
}