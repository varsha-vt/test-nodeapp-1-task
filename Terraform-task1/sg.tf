# Using a http data source to get Self IP
data "http" "myip" {
  url = "https://api.ipify.org"
}

# Create Security Group for Bastion Host SG
resource "aws_security_group" "bastion_host" {
  name        = "bastion_host_sg"
  description = "bastion_host2_sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Public"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Bastion-Host-SG"
    Terraform = var.upgrad
  }
}

# Private Instances Security Group
resource "aws_security_group" "private_instance" {
  name        = "private_instance_sg"
  description = "private_instance_sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "Private"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Private-Instance-SG"
    Terraform = var.upgrad
  }
}

# Public Web Security Group
resource "aws_security_group" "public_web" {
  name        = "public-web-sg"
  description = "public-web-sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "Public"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public-Web-SG"
    Terraform = var.upgrad
  }
}