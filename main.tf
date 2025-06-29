
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block           = var.my-block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_a" {
  count             = 2
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.my-newnet[count.index]
  availability_zone = var.my-azs[count.index]

  tags = {
    Name = "public-subnet-a${var.my-azs[count.index]}"
  }
}

resource "aws_subnet" "subnet_b" {
  count             = 2
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.my-oldnet[count.index]
  availability_zone = var.my-azs[count.index]

  tags = {
    Name = "public-subnet-b${var.my-azs[count.index]}"
  }
}



# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "public-rt"
  }
}

# Route to Internet via IGW
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.subnet_a[count.index].id
  route_table_id = aws_route_table.public.id
}


# Elastic IP for NAT
########################
resource "aws_eip" "nat" {
  count = 2
  vpc   = true
}

########################
# NAT Gateway (placed in first public subnet)
########################
resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.subnet_a[count.index].id

  tags = {
    Name = "main-nat"
  }
}
# Route Table for Private Subnets
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "private-rt"
  }
}

# Route to Internet via NAT Gateway
resource "aws_route" "private_nat" {
  count                  = 2
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
# Associate private subnets with private route table
resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.subnet_b[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

