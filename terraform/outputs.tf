output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.kubeforge_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.kubeforge_public_subnet.id
}

output "instance_public_ips" {
  description = "Public IP addresses of created EC2 instances"
  value       = aws_instance.nodes[*].public_ip
}

output "controller_public_ips" {
  description = "Public IP addresses of controller EC2 instance"
  value       = aws_instance.controller.public_ip
}

output "private_key" {
  value     = tls_private_key.pk.private_key_pem
  sensitive = true
}

output "ssh_user" {
  value = var.ssh_user
}

output "key_path" {
  value = var.key_path
}

output "log_file" {
  value = var.log_file
}
