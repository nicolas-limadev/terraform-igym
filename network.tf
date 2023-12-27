resource "aws_vpc" "vpc_gym" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name  = "VPC"
    Owner = "iGym"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc_gym.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name  = "Subnet Public"
    Owner = "iGym"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc_gym.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name  = "Subnet Private"
    Owner = "iGym"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc_gym.id

  tags = {
    Name  = "gateway internet"
    Owner = "iGym"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_gym.id

  route {
    cidr_block = aws_subnet.subnet_public.cidr_block
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name  = "Route Table Public"
    Owner = "iGym"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_gym.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name  = "Route Table Private"
    Owner = "iGym"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gateway]

  tags = {
    Name  = "NAT IP Elastic"
    Owner = "iGym"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public.id

  tags = {
    Name  = "gateway NAT"
    Owner = "iGym"
  }

  depends_on = [aws_internet_gateway.gateway]
}

