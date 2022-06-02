variable "prefix" {
  type = string
  description = "value"
  default = "k8s"
}

variable "ssh_connection" {
  type = object({
    ssh_user = string
    ssh_password = string
  })
}

variable vsphere_connection {
  type = object({
    vsphere_server = string
    vsphere_user = string
    vsphere_password = string
    vsphere_vm_folder = string
  })
  description = "value"
}

variable vm_count {
  type = object({
    controllers = number
    workers = number
  })
  description = "value"
  default = {
    controllers = 1
    workers = 3
  }
}

variable "vm_hardware_settings" {
  type = object({
    cpu = number
    mem = number
  })
  description = "value"
  default = {
    cpu = 2
    mem = 4096
  }
}

variable "vm_network_settings" {
  type = object({
    ipv4_netmask = number
    ipv4_cidr = string
    ipv4_gateway = string
    start_ipv4_address = number
    dns_server_list = list(string)
    dns_domain = string
  })
  description = "value"
}

variable "vsphere_settings" {
  type = object({
    vsphere_datacenter = string
    vsphere_datastore = string
    vsphere_cluster = string
    vsphere_network = string
    vsphere_template = string
  })
  description = "value"
}