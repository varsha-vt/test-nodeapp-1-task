# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Creating the VPC
resource "aws_vpc" "this" {
  cidr_block       = "10.100.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Assignment-Task1-VPC"
    Terraform = var.upgrad
  }
}

# Creating the Internet gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Assignment-Task1-IGW"
    Terraform = var.upgrad
  }
}

# Creating the 2 Public Subnets in each availability zone
resource "aws_subnet" "public" {
  count = var.net_count
  vpc_id = aws_vpc.this.id
  cidr_block = "10.100.${1+count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "Assignmnet-Public-Subnet-${1+count.index}"
    Terraform = var.upgrad
  }
}

# Creating the 2 Private Subnets in each availability zone
resource "aws_subnet" "private" {
  count = var.net_count
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.100.${3+count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "Assignmnet-Private-Subnet-${1+count.index}"
    Terraform = var.upgrad
  }
}

# Creating the elastic IP
 resource "aws_eip" "eip" {
  vpc      = true
}

# Creating the NAT Gatway
resource "aws_nat_gateway" "network_interface" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public.0.id

  tags = {
    Name = "Assignmnet-NAT"
    Terraform = var.upgrad
  }
  depends_on = [aws_internet_gateway.igw]
}

# Creating the public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Assignment-routetable-public"
    Terraform = var.upgrad
  }
}

# Associating public subnets to public route table
resource "aws_route_table_association" "public" {
  count = var.net_count
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = aws_route_table.public.id
}

# Creating Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.network_interface.id
  }
  tags = {
    Name = "Assignment-routetable-private"
    Terraform = var.upgrad
  }
}
# Associating private subnets to private route table
resource "aws_route_table_association" "private" {
  count = var.net_count
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = aws_route_table.private.id
}
