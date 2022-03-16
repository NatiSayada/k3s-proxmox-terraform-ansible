[master]
${k3s_master_ip}

[node]
${k3s_node_ip}

[k3s_cluster:children]
master
node