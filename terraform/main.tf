# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

#
# Create VPC
resource "aws_vpc" "kubeforge_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "kubeforge-vpc"
  }
}
#
# Create Internet Gateway
resource "aws_internet_gateway" "kubeforge_igw" {
  vpc_id = aws_vpc.kubeforge_vpc.id

  tags = {
    Name = "kubeforge-igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "kubeforge_public_subnet" {
  vpc_id                  = aws_vpc.kubeforge_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "kubeforge-public-subnet"
  }
}

# Create Route Table
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

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.kubeforge_public_subnet.id
  route_table_id = aws_route_table.kubeforge_public_rt.id
}

# Create Security Group
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


# Generate a key pair
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}

# Create EC2 Instances
resource "aws_instance" "kubeforge_instances" {
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
