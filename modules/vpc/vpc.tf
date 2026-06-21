#creating VPC

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags                 = { Name = "terraform-vpc" }
}

#Creating public subnets

resource "aws_subnet" "public_TF" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)

  tags = {
    Name = "terraform-public-${count.index}"
  }
}

#Creating private subnets

resource "aws_subnet" "private_TF" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 2)

  tags = {
    Name = "terraform-private-${count.index}"
  }
}

#Creating and attaching Internet Gateway

resource "aws_internet_gateway" "TF_IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway_by_terraform"
  }
}

#Creating Elastic IP for NAT Gateway

resource "aws_eip" "nat_eip_TF" {
  domain = "vpc"
}

#Creating NAT Gateway in the first public subnet

resource "aws_nat_gateway" "TF_NAT" {
  allocation_id = aws_eip.nat_eip_TF.id
  subnet_id     = aws_subnet.public_TF[0].id
  tags          = { Name = "terraform-nat" }
}

#creating route table for public subnets

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TF_IGW.id
  }
  tags = { Name = "terraform-public-rt" }
}

#creating route table for private subnets

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.TF_NAT.id
  }
  tags = { Name = "terraform-private-rt" }
}

#creating route table association for public & private subnets

resource "aws_route_table_association" "public_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.public_TF[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.private_TF[count.index].id
  route_table_id = aws_route_table.private_rt.id
}