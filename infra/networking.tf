data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs          = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  cluster_name = "hivemind_${var.environment}_eks"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "hivemind-${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                          = "hivemind-${var.environment}-public-${local.azs[count.index]}"
    Environment                                   = var.environment
    ManagedBy                                     = var.managedByTerraform
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = local.azs[count.index]

  tags = {
    Name                                          = "hivemind-${var.environment}-private-${local.azs[count.index]}"
    Environment                                   = var.environment
    ManagedBy                                     = var.managedByTerraform
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "hivemind-${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "hivemind-${var.environment}-public-rt"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Single NAT gateway (not one per AZ) to keep cost down for a dev environment.
# Trade-off: private subnet egress has a single point of failure across AZs.
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "hivemind-${var.environment}-nat-eip"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "hivemind-${var.environment}-nat"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "hivemind-${var.environment}-private-rt"
    Environment = var.environment
    ManagedBy   = var.managedByTerraform
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
