provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`
resource "aws_vpc" "Vpc-Terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "Vpc-terraform"
  }

}

resource "aws_internet_gateway" "Igw-Terraform" {
  vpc_id = aws_vpc.Vpc-Terraform.id
  tags = {
    Name = "Igw-Terraform"
  }
}

resource "aws_subnet" "Public-Subnet-Terraform" {
  vpc_id     = aws_vpc.Vpc-Terraform.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public-Subnet-Terraform"
  }
}

resource "aws_route_table" "Public-RT-Terraform" {
  vpc_id = aws_vpc.Vpc-Terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw-Terraform.id
  }

  tags = {
    Name    = "Public-RT-Terraform"
    Service = "Terraform"
  }
}
resource "aws_route_table_association" "Public-RTA-Terraform" {
  subnet_id      = aws_subnet.Public-Subnet-Terraform.id
  route_table_id = aws_route_table.Public-RT-Terraform.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Vpc-Terraform.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_all"
  }
}
