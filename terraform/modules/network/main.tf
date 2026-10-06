data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
    Tier = "frontend"
  }
}

resource "aws_subnet" "backend" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-backend-subnet"
    Tier = "backend"
  }
}

resource "aws_subnet" "database" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-database-subnet"
    Tier = "database"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# The backend requires a public IP for direct Ansible management as requested.
# This route table provides the backend subnet with IGW reachability while the
# backend security group restricts SSH to the supplied admin/pipeline CIDRs.
resource "aws_route_table" "backend" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-backend-rt"
  }
}

resource "aws_route_table_association" "backend" {
  subnet_id      = aws_subnet.backend.id
  route_table_id = aws_route_table.backend.id
}

resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-frontend-sg"
  description = "Security group for the EpicBook frontend"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "sg-${var.project_name}-frontend"
  }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ssh" {
  for_each          = toset(compact([var.allowed_admin_ip, var.pipeline_agent_ip]))
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "frontend_all" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg"
  description = "Security group for the EpicBook backend"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "sg-${var.project_name}-backend"
  }
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  for_each          = toset(compact([var.allowed_admin_ip, var.pipeline_agent_ip]))
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "backend_app" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.frontend.id
  from_port                    = var.backend_app_port
  to_port                      = var.backend_app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "backend_all" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "Security group for the EpicBook RDS MySQL database"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "sg-${var.project_name}-database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_mysql" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.backend.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "database_all" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
