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