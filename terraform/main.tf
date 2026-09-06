resource "azurerm_resource_group" "desafio" {
  name     = var.prefix
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.desafio.location
  resource_group_name = azurerm_resource_group.desafio.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-nic"
  resource_group_name  = azurerm_resource_group.desafio.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.desafio.location
  resource_group_name = azurerm_resource_group.desafio.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  computer_name       = "${var.prefix}-vm"
  location            = azurerm_resource_group.desafio.location
  resource_group_name = azurerm_resource_group.desafio.name
  size                = var.vm_size

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand("~/.ssh/ssh-key-2026-08-29.key.pub"))
  }

  os_disk {
    name                 = "${var.prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.desafio.location
  resource_group_name = azurerm_resource_group.desafio.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.desafio.location
  resource_group_name = azurerm_resource_group.desafio.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}