terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.1.1"
    }
  }
  required_version = ">= 0.13"
}