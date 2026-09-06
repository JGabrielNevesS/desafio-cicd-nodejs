output "public_ip_address" {
  description = "IP público da máquina virtual"
  value       = azurerm_public_ip.main.ip_address
}