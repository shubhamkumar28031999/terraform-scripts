// VPC creation

resource "aws_vpc" "Lakeside_VPC" {
    cidr_block           = "10.1.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
 
    tags = {
        Name = "Lakeside VPC"
    }
}


// Subnet creation 

// 1. Public Subnet for Jump server
resource "aws_subnet" "Lakeside_Jump_Subnet" {
    vpc_id                  = aws_vpc.Lakeside_VPC.id
    cidr_block              = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    tags = {
      Name = "Lakeside Jump Public Subnet"
    }
}

// 2. Private Subnet 
resource "aws_subnet" "Lakeside_Subnet" {
    vpc_id                  = aws_vpc.Lakeside_VPC.id
    map_public_ip_on_launch = "true"
    cidr_block              = "10.1.2.0/24"
    tags = {
      Name = "Lakeside Private Subnet"
    }
}

// Internet gateway

resource "aws_internet_gateway" "Lakeside_VPC_GW" {
    vpc_id = aws_vpc.Lakeside_VPC.id
    tags = {
            Name = "Lakeside VPC Internet Gateway"
    }
}


resource "aws_route_table" "Lakeside_VPC_route_table" {
    vpc_id = aws_vpc.Lakeside_VPC.id
    tags = {
            Name = "Lakeside VPC Route Table"
    }
}

resource "aws_route" "Lakeside_VPC_internet_access" {
    route_table_id         = aws_route_table.Lakeside_VPC_route_table.id
    destination_cidr_block =  "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.Lakeside_VPC_GW.id
}

resource "aws_route_table_association" "Lakeside_VPC_association" {
    subnet_id      = aws_subnet.Lakeside_Jump_Subnet.id
    route_table_id = aws_route_table.Lakeside_VPC_route_table.id
}


resource "aws_eip" "jump-eip" {
    vpc              = true
    public_ipv4_pool = "amazon"
}


resource "aws_nat_gateway" "locust-eip" {
    depends_on=[aws_eip.jump-eip]
    allocation_id = aws_eip.jump-eip.id
    subnet_id     = aws_subnet.Lakeside_Jump_Subnet.id
    tags = {
        Name = "Locust_NAT_Gateway"
      }
}

// Route table for SNAT in private subnet

resource "aws_route_table" "private_subnet_route_table" {
    depends_on=[aws_nat_gateway.locust-eip]
    vpc_id = aws_vpc.Lakeside_VPC.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.locust-eip.id
    }

    tags = {
      Name = "private_subnet_route_table"
    }
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
    depends_on = [aws_route_table.private_subnet_route_table]
    subnet_id      = aws_subnet.Lakeside_Subnet.id
    route_table_id = aws_route_table.private_subnet_route_table.id
}
