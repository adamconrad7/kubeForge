[server]
server ansible_host=${server_ip} private_ip=${server_private_ip}

[agent]
%{ for index, ip in agent_ips ~}
agent${index + 1} ansible_host=${ip} 
%{ endfor ~}

[all:vars]
ansible_ssh_private_key_file=${key_path}
ansible_user=ec2-user
