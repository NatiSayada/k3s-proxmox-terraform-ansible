terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.8.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.pm_host}:8006/api2/json"
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
  pm_parallel     = 10
  pm_timeout      = 300
  #  pm_debug = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = var.num_k3s_masters
  name        = "k3s-master-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = 4

  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.networkrange},gw=${var.gateway}"

}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = var.num_k3s_nodes
  name        = "k3s-worker-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = 4

  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.networkrange},gw=${var.gateway}"

}

data "template_file" "k8s" {
  template = file("./templates/k8s.tpl")
  vars = {
    k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
  }
}

resource "local_file" "k8s_file" {
  content  = data.template_file.k8s.rendered
  filename = "../inventory/my-cluster/hosts.ini"
}

resource "local_file" "var_file" {
  source = "../inventory/sample/group_vars/all.yml"
  filename = "../inventory/my-cluster/group_vars/all.yml"
}

output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}

output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
