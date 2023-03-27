# Resources to create private subnet and connection

# resource "aws_subnet" "private_ap_east_1a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "ap-east-1a"

#   tags = {
#     "Name"                            = "private-us-east-1a"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_subnet" "private_ap_east_1b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "ap-east-1b"

#   tags = {
#     "Name"                            = "private-ap-east-1b"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_eip" "nat_ip" {
#   vpc = true

#   tags = {
#     Name = "nat"
#   }
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_ip.id
#   subnet_id     = aws_subnet.public_ap_east_1a.id

#   tags = {
#     Name = "nat_gw"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_route_table_association" "private_ap_east_1a" {
#   subnet_id      = aws_subnet.private_ap_east_1a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_ap_east_1b" {
#   subnet_id      = aws_subnet.private_ap_east_1b.id
#   route_table_id = aws_route_table.private.id
# }