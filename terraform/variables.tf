variable "subscription_id" {
  description = "Id da subscription do Azure."
  type        = string
}

variable "prefix" {
  default = "tfvmex"
}

variable "location" {
  default = "chilecentral"
}

variable "vm_size" {
  default = "Standard_B2als_v2"
}

variable "admin_username" {
  default = "joao"
}
