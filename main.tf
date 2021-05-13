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
		Name = var.aws_vpc
	}
}

# block of code to create internet gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = var.aws_ig
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
		Name = var.aws_rt
	}
}

# block of code to create app subnet
resource "aws_subnet" "terraform_app_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = var.app_cidr
	availability_zone = var.a_zone
	tags = {
		Name = var.aws_app
	}
}

# block of code to create db subnet
resource "aws_subnet" "terraform_db_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = var.db_cidr
	availability_zone = var.a_zone
	tags = {
		Name = var.aws_db
	}
}

# associate route tables with app subnet
resource "aws_route_table_association" "app" {
  subnet_id = aws_subnet.terraform_app_subnet.id
  route_table_id = aws_route_table.terraform_rt.id
}

# associate route tables with db subnet
resource "aws_route_table_association" "db" {
  subnet_id = aws_subnet.terraform_db_subnet.id
  route_table_id = aws_route_table.terraform_rt.id
}

# block of code to create an app security group
resource "aws_security_group" "terraform_public_sg" {
	name = var.app_sg
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
		cidr_blocks =	[var.my_ip]
	}

	egress {
		from_port =		0
		to_port = 		0
		protocol = 		"-1"
		cidr_blocks =	["0.0.0.0/0"]
	}
}

# block of code to create a db security group
resource "aws_security_group" "terraform_priv_sg" {
	name = var.db_sg
	vpc_id = aws_vpc.terraform_vpc.id

	ingress {
		from_port = 	"0"
		to_port = 		"0"
		protocol =		"-1"
		cidr_blocks = 	[var.app_cidr]
	}

	egress {
		from_port =		0
		to_port = 		0
		protocol = 		"-1"
		cidr_blocks =	["0.0.0.0/0"]
	}
}

# Launching an EC2 instance from AMI
resource "aws_instance" "db_instance"{
	ami = var.db_ami_id
	subnet_id = aws_subnet.terraform_db_subnet.id
	vpc_security_group_ids = ["${aws_security_group.terraform_priv_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = false
	private_ip = "32.34.2.42"
	key_name = var.aws_key_name
	tags = {
		Name = var.aws_db
	}
}

# Launching an EC2 instance from AMI
resource "aws_instance" "app_instance"{
	ami = var.webapp_ami_id
	subnet_id = aws_subnet.terraform_app_subnet.id
	vpc_security_group_ids = ["${aws_security_group.terraform_public_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = true
	key_name = var.aws_key_name

	tags = {
		Name = var.aws_app
	}

	provisioner "file" {
		source =		"./app/init.sh"
		destination =	"/tmp/init.sh"
	}
	
	provisioner "remote-exec" {
    	inline = [
    		"chmod +x /tmp/init.sh",
    		"bash /tmp/init.sh",
    	]
    }

  	connection {
    	type        = "ssh"
    	user        = "ubuntu"
    	private_key = file(var.aws_key_path)
    	host        = self.public_ip
  	}
}