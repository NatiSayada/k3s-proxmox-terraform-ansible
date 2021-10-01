terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.8.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.3.102:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "Xx7437338"
  pm_tls_insecure = "true"
  pm_parallel     = 10
}

variable "pvt_key" {
  default = "~/.ssh/proxk3s"
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = 1
  name        = "k3s-master-${count.index}"
  target_node = "pve"
  clone       = "ubuntu-2004-cloudinit-template"
  os_type     = "cloud-init"
  agent       = 1
  memory      = "2048"
  cores       = 4

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = self.default_ipv4_address
      type        = "ssh"
      user        = "nsayada"
      private_key = file(var.pvt_key)
    }
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = 4
  name        = "k3s-worker-${count.index}"
  target_node = "pve"
  clone       = "ubuntu-2004-cloudinit-template"
  os_type     = "cloud-init"
  agent       = 1
  memory      = "4096"
  cores       = 4

  provisioner "remote-exec" {
    inline = ["sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = self.default_ipv4_address
      type        = "ssh"
      user        = "nsayada"
      private_key = file(var.pvt_key)
    }
  }

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
  filename = "/home/nsayada/k3s-ansible/inventory/my-cluster/hosts.ini"
}

output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}
output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
