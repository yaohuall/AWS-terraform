resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "public_ap_east_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "ap-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-ap-east-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "public_ap_east_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "ap-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-ap-east-1b"
    # used to create public load balancer
    "kubernetes.io/role/elb"     = "1"
    # Owned: Tag all public and private subnets that your cluster uses for load balancer resources 
    "kubernetes.io/cluster/data-cluster" = "owned"
  }
}

resource "aws_route_table" "public-1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-1a"
  }
}

resource "aws_route_table" "public-1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-1b"
  }
}

resource "aws_route_table_association" "public_ap_east_1a" {
  subnet_id      = aws_subnet.public_ap_east_1a.id
  route_table_id = aws_route_table.public-1a.id
}

resource "aws_route_table_association" "public_ap_east_1b" {
  subnet_id      = aws_subnet.public_ap_east_1b.id
  route_table_id = aws_route_table.public-1b.id
}