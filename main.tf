# Initialise Terraform
# Providers?
# AWS

# This code will eventually launch an EC2 instance

# Provider is a keyword in Terraform to define the name of cloud provider

# Syntax:
provider "aws"{
	region = "eu-west-1"
}

# Resource is the keyword that allows us to add aws resources

# block of code to create a vpc
resource "aws_vpc" "terraform_vpc" {
	cidr_block =		"32.34.0.0/16"
	instance_tenancy =	"default"
	tags = {
		Name = "eng84_jordan_terraform_vpc"
	}
}

# block of code to create internet gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "eng84_jordan_terraform_igw"
  }
}

# create route table
resource "aws_route_table" "terraform_rt" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
  	cidr_block = "0.0.0.0/0"
  	gateway_id = aws_internet_gateway.terraform_igw.id
  }
  tags = {
  	Name = "eng84_jordan_terraform_rt"
  }
}

# block of code to create a subnet
resource "aws_subnet" "terraform_app_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = "32.34.12.0/24"
	availability_zone = "eu-west-1b"
	tags = {
		Name = "eng84_jordan_terraform_app"
	}
}

# associate route tables with subnets
resource "aws_route_table_association" "app" {
  subnet_id = aws_subnet.terraform_app_subnet.id
  route_table_id = aws_route_table.terraform_rt.id
}

# block of code to create a security group
resource "aws_security_group" "terraform_public_sg" {
	name = "eng84_jordan_terraform_sg"
	description = "app security group"
	vpc_id = aws_vpc.terraform_vpc.id

	ingress {
		from_port = 	"80"
		to_port = 		"80"
		protocol =		"tcp"
		cidr_blocks = 	["0.0.0.0/0"]
	}

	ingress {
		from_port =		"22"
		to_port =		"22"
		protocol =		"tcp"
		cidr_blocks =	self.public_ip #"46.64.78.97/32"	
		# insert IP here
	}

	egress {
		from_port =		0
		to_port = 		0
		protocol = 		"-1"
		cidr_blocks =	["0.0.0.0/0"]
	}
}

# Launching an EC2 instance from AMI
resource "aws_instance" "app_instance"{
	ami = var.webapp_ami_id
	subnet_id = aws_subnet.terraform_app_subnet.id
	vpc_security_group_ids = ["${aws_security_group.terraform_public_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
		Name = var.name
	}
	key_name = var.aws_key_name
}

  provisioner "remote-exec" {
    inline = ".app/init.sh.tpl"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_path)
    host        = self.public_ip
  }
