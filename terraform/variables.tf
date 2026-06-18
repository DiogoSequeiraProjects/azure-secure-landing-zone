variable "location" {
  description = "Azure region for the landing zone resources."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "rg-secure-landing-zone"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "vnet-secure-lz"
}
