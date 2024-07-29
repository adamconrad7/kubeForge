provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "kubeforge_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "kubeforge-vpc"
  }
}

resource "aws_internet_gateway" "kubeforge_igw" {
  vpc_id = aws_vpc.kubeforge_vpc.id

  tags = {
    Name = "kubeforge-igw"
  }
}

resource "aws_subnet" "kubeforge_public_subnet" {
  vpc_id                  = aws_vpc.kubeforge_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "kubeforge-public-subnet"
  }
}

resource "aws_route_table" "kubeforge_public_rt" {
  vpc_id = aws_vpc.kubeforge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubeforge_igw.id
  }

  tags = {
    Name = "kubeforge-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.kubeforge_public_subnet.id
  route_table_id = aws_route_table.kubeforge_public_rt.id
}

resource "aws_security_group" "kubeforge_sg" {
  name        = "kubeforge-sg"
  description = "Security group for KubeForge instances"
  vpc_id      = aws_vpc.kubeforge_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubeforge-sg"
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}

resource "aws_instance" "controller" {
  #count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.kubeforge_sg.id]
  subnet_id              = aws_subnet.kubeforge_public_subnet.id

  tags = {
    Name = "kubeforge-controller"
  }
}

resource "aws_instance" "nodes" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.kubeforge_sg.id]
  subnet_id              = aws_subnet.kubeforge_public_subnet.id

  tags = {
    Name = "kubeforge-instance-${count.index + 1}"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible_template.tpl", {
    controller_ip = aws_instance.controller.public_ip
	#change to nodes
    instance_ips = aws_instance.nodes[*].public_ip
    ssh_user   = var.ssh_user
    key_path = abspath(var.key_path)
  })
  filename = "${path.module}/../ansible/inventory/hosts.yml"
}

