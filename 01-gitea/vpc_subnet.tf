# VPC
resource "aws_vpc" "assessment_vpc" {
  cidr_block           = var.assessment_vpc
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.assessment_vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = element(cidrsubnets(var.assessment_vpc, 8, 4, 4), count.index)

  tags = {
    "Name" = "public-Subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.assessment_vpc.id

  tags = {
    "Name" = "Internet-Gateway"
  }
}

# Public Route Table:
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.assessment_vpc.id

  tags = {
    "Name" = "Public-RouteTable"
  }
}

# Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Route Table Association
resource "aws_route_table_association" "public_rt_association" {
  count          = 3
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}
