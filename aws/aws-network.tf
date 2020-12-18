# vpc and gateway
resource "aws_vpc" "nc-vpc" {
  cidr_block              = var.vpc_cidr
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  tags                    = {
    Name                  = "nc-vpc"
  }
}

# internet gateway 
resource "aws_internet_gateway" "nc-gw" {
  vpc_id                  = aws_vpc.nc-vpc.id
  tags                    = {
    Name                  = "nc-gw"
  }
}

# public route table
resource "aws_route_table" "nc-pubrt" {
  vpc_id                  = aws_vpc.nc-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.nc-gw.id
  }
  tags                    = {
    Name                  = "nc-pubrt"
  }
}

# public subnet
resource "aws_subnet" "nc-pubnet" {
  vpc_id                  = aws_vpc.nc-vpc.id
  availability_zone       = data.aws_availability_zones.nc-azs.names[var.aws_az]
  cidr_block              = var.pubnet_cidr
  tags                    = {
    Name                  = "nc-pubnet"
  }
  depends_on              = [aws_internet_gateway.nc-gw]
}

# public route table associations
resource "aws_route_table_association" "rt-assoc-pubnet" {
  subnet_id               = aws_subnet.nc-pubnet.id
  route_table_id          = aws_route_table.nc-pubrt.id
}
