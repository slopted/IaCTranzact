variable "DefaultLocation" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "name_prefix" {
  default     = "IaCTranzact"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "rg_name" {
  default     = "${var.name_prefix}_rg"
  description = "Name of the resource group."
}

variable "nsg_name" {
  default     = "${var.name_prefix}_nsg"
  description = "Name of the Network Security Group."
}

variable "vnet_name" {
  default     = "${var.name_prefix}_vnet"
  description = "Name of the Virtual Network."
}
