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
  value       = aws_instance.kubeforge_instances[*].public_ip
}

output "private_key" {
  value     = tls_private_key.pk.private_key_pem
  sensitive = true
}

output "ec2_user" {
  value = var.ec2_user
}

output "key_file" {
  value = var.key_file
}


output "log_file" {
  value = var.log_file
}
