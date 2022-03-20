
output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}

output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
