variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "vm_name_prefix" {}
variable "vm_controller_count" {
  description = "Number of controller nodes to deploy"
  type = string
  default = "1"
}
variable "vm_worker_count" {
  description = "Number of worker nodes to deploy"
  type = string
  default = "3"
}