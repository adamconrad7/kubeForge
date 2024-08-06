variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone"
  default     = "us-west-2a"
}

variable "server_instance_type" {
  description = "EC2 instance type"
  default     = "t3a.medium"
}

variable "agent_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 0
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-074be47313f84fa38"  # Amazon Linux 2023 x86
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  default = "kubeForgeKey"
}

variable "key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "path/to/default/key.pem"
}

variable "ssh_user" {
  default = "ec2-user"
}

variable "log_file" {
  default = "../setup.log"
}
