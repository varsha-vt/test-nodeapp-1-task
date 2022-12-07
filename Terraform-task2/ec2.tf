# Create the key
resource "aws_key_pair" "deployer" {
  key_name   = "upgrad-key"
  public_key = var.public_key
}

data "aws_ami" "amazon_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create EC2 instance - Bastion
resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazon_ubuntu.id
  key_name = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.0.id
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  associate_public_ip_address = true

  tags = {
    Name = "Assignment-Bastion-Instance"
    Terraform = var.upgrad
  }
}

# Create EC2 instance - Jenkins
resource "aws_instance" "jenkins" {
  ami = data.aws_ami.amazon_ubuntu.id
  key_name = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.0.id
  vpc_security_group_ids = [aws_security_group.private_instance.id]
#   associate_public_ip_address = true

  tags = {
    Name = "Assignment-Jenkins-Instance"
    Terraform = var.upgrad
  }
}

# Create EC2 instance - App
resource "aws_instance" "app" {
  ami = data.aws_ami.amazon_ubuntu.id
  key_name = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.1.id
  vpc_security_group_ids = [aws_security_group.private_instance.id]
  associate_public_ip_address = false

  tags = {
    Name = "Assignment-App-Instance"
    Terraform = var.upgrad
  }
}