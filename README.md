# Build a Kubernetes cluster using k3s via Ansible and Terraform

Author: <https://github.com/itwars> and <https://github.com/NatiSayada>

## K3s Ansible Playbook

Build a Kubernetes cluster using Ansible with k3s. The goal is easily install a Kubernetes cluster on machines running:

- [X] Debian
- [X] Ubuntu
- [X] CentOS

on processor architecture:

- [X] x64
- [X] arm64
- [X] armhf

## System requirements

Deployment environment must have Ansible 2.4.0+
Master and nodes must have passwordless SSH access
Terraform installed
Proxmox server

## Usage

### proxmox setup
This setup is relayig on cloud-init image and its save a lot of the image configuration.
I use ubuntu focal image, to configure the cloud-init image you will need to connect to a linux server and run the following:

install image tools on the server (you will need another server, this tools cannot be installed on proxmox)

```bash
apt-get install libguestfs-tools
```

Get the image that you would like to work with.
you can browse to <https://cloud-images.ubuntu.com> and select any other version that you wold like to work with.
it can also work for debian and centos (R.I.P)

```bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
```

update the image and install proxmox agent - this is a must if we want terrafom to work properly.
it can take a minute to add the packege to the image.

```bash
virt-customize --install qemu-guest-agent
```

now we need will create a new vm

```bash
qm create 9000 --name "ubuntu-focal-cloudinit-template" --memory 2048 --net0 virtio,bridge=vmbr0
```

for ubuntu images, rename the image suffix

```bash
mv focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64.qcow2
```

import the disk

```bash
qm importdisk 9000 focal-server-cloudimg-amd64.qcow2 local-lvm
```

configure the vm to use the image

```bash
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
```

### terraform setup

Rename the file `terraform/vars.sample` to `terraform/vars.tf` and update all the vars.

to run the terrafom, you will need to cd into `terraform` and run:

```bash
terraform init
terraform plan
terraform apply
```

it can take some time to create the servers on proxmox but you can monitor them over proxmox.

### ansible setup

First create a new directory based on the `sample` directory within the `inventory` directory:

```bash
cp -R inventory/sample inventory/my-cluster
```

Second, edit `inventory/my-cluster/hosts.ini` to match the system information gathered above. For example:

```bash
[master]
192.16.35.12

[node]
192.16.35.[10:11]

[k3s_cluster:children]
master
node
```

If needed, you can also edit `inventory/my-cluster/group_vars/all.yml` to match your environment.

Start provisioning of the cluster using the following command:

```bash
ansible-playbook site.yml -i inventory/my-cluster/hosts.ini
```

## Kubeconfig

To get access to your **Kubernetes** cluster just

```bash
scp debian@master_ip:~/.kube/config ~/.kube/config
```
