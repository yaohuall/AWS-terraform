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

resource "aws_subnet" "public_us_east_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                     = "public_us_east_2a"
    "for-use-with-amazon-emr-managed-policies" = true
  }
}

resource "aws_route_table" "public-us-east-2a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-2a"
  }
}

resource "aws_route_table_association" "public_us_east_2a" {
  subnet_id      = aws_subnet.public_us_east_2a.id
  route_table_id = aws_route_table.public-us-east-2a.id
}


