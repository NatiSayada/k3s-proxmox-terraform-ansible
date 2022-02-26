variable "username" {
  description = "The username for the DB master user"
  type        = string
  sensitive = false
  default = ""

}
variable "password" {
  description = "The password for the DB master user"
  type        = string
  sensitive = true
  default = ""
}

variable "proxmox-host" {
  description = "The username for the DB master user"
  type        = string
}

variable "pvt_key" {}

variable "num_k3s_masters" {
 default = 1
}

variable "num_k3s_masters_mem" {
 default = "4096"
}

variable "num_k3s_nodes" {
 default = 4
}

variable "num_k3s_nodes_mem" {
 default = "4096"
}

variable "tamplate_vm_name" {}
