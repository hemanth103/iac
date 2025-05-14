variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "my-resource-group"
}

variable "resource_group_location" {
  description = "The location/region for the resource group."
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "my-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "my-subnet"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "nsg_name" {
  description = "The name of the network security group."
  type        = string
  default     = "my-nsg"
}
