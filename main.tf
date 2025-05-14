# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # or a later version
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet_address_space
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
  
  # Ensure subnet is fully provisioned before associating NSG
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Create a Network Security Group Rule (Optional - Add rules as needed)
resource "azurerm_network_security_rule" "nsg_rule_allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
  
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}

# Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "snet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  
  # Ensure both subnet and NSG are fully provisioned before attempting association
  depends_on = [
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg,
    azurerm_network_security_rule.nsg_rule_allow_ssh
  ]
}
