[control_plane]
conroller ansible_host=${controller_ip} ansible_user=${ssh_user}

[worker]
%{ for index, ip in instance_ips ~}
instance-${index} ansible_host=${ip} ansible_user=${ssh_user}
%{ endfor ~}

[all:vars]
ansible_ssh_private_key_file=${key_path}
