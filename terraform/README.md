<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.6 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.k8s_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.var_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [proxmox_vm_qemu.proxmox_vm_master](https://registry.terraform.io/providers/telmate/proxmox/latest/docs/resources/vm_qemu) | resource |
| [proxmox_vm_qemu.proxmox_vm_workers](https://registry.terraform.io/providers/telmate/proxmox/latest/docs/resources/vm_qemu) | resource |
| [template_file.k8s](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway"></a> [gateway](#input\_gateway) | n/a | `string` | `"192.168.3.1"` | no |
| <a name="input_master_ips"></a> [master\_ips](#input\_master\_ips) | List of ip addresses for master nodes | `any` | n/a | yes |
| <a name="input_networkrange"></a> [networkrange](#input\_networkrange) | n/a | `number` | `24` | no |
| <a name="input_num_k3s_masters"></a> [num\_k3s\_masters](#input\_num\_k3s\_masters) | n/a | `number` | `1` | no |
| <a name="input_num_k3s_masters_mem"></a> [num\_k3s\_masters\_mem](#input\_num\_k3s\_masters\_mem) | n/a | `string` | `"4096"` | no |
| <a name="input_num_k3s_nodes"></a> [num\_k3s\_nodes](#input\_num\_k3s\_nodes) | n/a | `number` | `2` | no |
| <a name="input_num_k3s_nodes_mem"></a> [num\_k3s\_nodes\_mem](#input\_num\_k3s\_nodes\_mem) | n/a | `string` | `"4096"` | no |
| <a name="input_pm_host"></a> [pm\_host](#input\_pm\_host) | The hostname or IP of the proxmox server | `string` | n/a | yes |
| <a name="input_pm_node_name"></a> [pm\_node\_name](#input\_pm\_node\_name) | name of the proxmox node to create the VMs on | `string` | `"pve"` | no |
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | The password for the proxmox user | `string` | n/a | yes |
| <a name="input_pm_tls_insecure"></a> [pm\_tls\_insecure](#input\_pm\_tls\_insecure) | Set to true to ignore certificate errors | `bool` | `false` | no |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | The username for the proxmox user | `string` | `"root@pam"` | no |
| <a name="input_pvt_key"></a> [pvt\_key](#input\_pvt\_key) | n/a | `any` | n/a | yes |
| <a name="input_tamplate_vm_name"></a> [tamplate\_vm\_name](#input\_tamplate\_vm\_name) | n/a | `any` | n/a | yes |
| <a name="input_worker_ips"></a> [worker\_ips](#input\_worker\_ips) | List of ip addresses for worker nodes | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Master-IPS"></a> [Master-IPS](#output\_Master-IPS) | n/a |
| <a name="output_worker-IPS"></a> [worker-IPS](#output\_worker-IPS) | n/a |
<!-- END_TF_DOCS -->
