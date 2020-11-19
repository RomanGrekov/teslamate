data "aws_availability_zones" "available" {
  state = "available"
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default" # many instance can be on one phisical machine
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags                 = local.common_tags
}

# subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = local.common_tags
}

# Internet gateway
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    { Name = "${local.project_env_name}-internet-gw" }
  )
}

# Route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = merge(
    local.common_tags,
    { Name = "${local.project_env_name}-public-route-table" }
  )
  depends_on = [aws_internet_gateway.main-gw]
}

# Route associations public
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main-public.id
}

# NAT gateway
resource "aws_eip" "nat" {
  vpc = "true"
  tags = merge(
    local.common_tags,
    { Name = "${local.project_env_name}-nat_gw" }
  )
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = merge(
    local.common_tags,
    { Name = local.project_env_name }
  )
}
