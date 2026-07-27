##############################################
# Virtual Private Cloud (VPC)
##############################################

resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })

}

##############################################
# Internet Gateway
##############################################

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })

}

##############################################
# Public Subnets
##############################################

resource "aws_subnet" "public_a" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-a"

    Tier = "Public"
  })

}

resource "aws_subnet" "public_b" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-b"

    Tier = "Public"
  })

}

##############################################
# Private Web Subnets
##############################################


resource "aws_subnet" "private_web_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-web-a"

    Tier = "Private-Web"
  })

}

resource "aws_subnet" "private_web_b" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-web-b"

    Tier = "Private-Web"
  })

}

##############################################
# Private Database Subnets
##############################################

resource "aws_subnet" "private_db_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-db-a"

    Tier = "Database"
  })

}

resource "aws_subnet" "private_db_b" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-db-b"

    Tier = "Database"
  })

}

####################################
# Elastic IP for NAT Gateway A
####################################

resource "aws_eip" "nat_a" {

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-eip-a"
  })

}

####################################
# Elastic IP for NAT Gateway B
####################################

resource "aws_eip" "nat_b" {

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-eip-b"
  })

}

####################################
# NAT Gateway A
####################################

resource "aws_nat_gateway" "nat_a" {

  allocation_id = aws_eip.nat_a.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-a"
  })

}
####################################
# NAT Gateway B
####################################

resource "aws_nat_gateway" "nat_b" {

  allocation_id = aws_eip.nat_b.id

  subnet_id = aws_subnet.public_b.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-b"
  })

}

####################################
# Public Route Table
####################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main.id

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })

}

##############################################
# Private Route Tables
##############################################


resource "aws_route_table" "private_web_a" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_a.id

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-web-a-rt"
  })

}

resource "aws_route_table" "private_web_b" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_b.id

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-web-b-rt"
  })

}

resource "aws_route_table" "private_db" {

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-db-rt"
  })

}

##############################################
# Route Table Associations
##############################################


resource "aws_route_table_association" "public_a" {

  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_b" {

  subnet_id = aws_subnet.public_b.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private_web_a" {

  subnet_id = aws_subnet.private_web_a.id

  route_table_id = aws_route_table.private_web_a.id

}

resource "aws_route_table_association" "private_web_b" {

  subnet_id = aws_subnet.private_web_b.id

  route_table_id = aws_route_table.private_web_b.id

}

resource "aws_route_table_association" "private_db_a" {

  subnet_id = aws_subnet.private_db_a.id

  route_table_id = aws_route_table.private_db.id

}

resource "aws_route_table_association" "private_db_b" {

  subnet_id = aws_subnet.private_db_b.id

  route_table_id = aws_route_table.private_db.id

}