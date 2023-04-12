# Resources to create private subnet and connection

resource "aws_subnet" "private_us_east_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    "Name" = "private-us-east-2a"
  }
}

resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_us_east_2a.id

  tags = {
    Name = "nat_gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private-2a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-1a"
  }
}

resource "aws_route_table_association" "private_us_east_2a" {
  subnet_id      = aws_subnet.private_us_east_2a.id
  route_table_id = aws_route_table.private-2a.id
}
