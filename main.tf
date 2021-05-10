# Initialise Terraform
# Providers?
# AWS

# This code will eventually launch an EC2 instance

# Provider is a keyword in Terraform to define the name of cloud provider

# Syntax:
provider "aws"{
	region = "eu-west-1"
}

# Launching an EC2 instance from AMI
# Resource is the keyword that allows us to add aws resources

resource "aws_instance" "app_instance"{
	# add the AMI id between "ami-08412dcc11680fa41"
	ami = "ami-08412dcc11680fa41"
	# add type of instance to launch
	instance_type = "t2.micro"
	# enable public IP for app
	associate_public_ip_address = true
	tags = {
		Name = "eng84_jordan_terraform_app"
	}
	key_name = "enter ssh key.pem"
}

# block of code to create a default VPC
resource "aws_default_vpc" "default" {
	# cidr_block = "32.32.0.0/16"
	# instance_tenancy = "default"
	tags = {
	Name = "eng84_jordan_vpc_terraform"
	}
}

# Terraform init
# Terraform plan
# Terraform apply
# Terraform destroy
