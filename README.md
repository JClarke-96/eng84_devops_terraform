# Terraform
## Cloud Networks
![alt text](https://cdn.discordapp.com/attachments/836898832637624370/841615996284043274/public-private-hybrid-clouds.png)

## What is Terraform?
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.

## What are the benefits of Terraform?
- Simple to install
- Improved multi-cloud infrastructure deployment
- Simple to use
- Reduced development costs
- Reduced time to provision

## Using Terraform
![alt text](https://miro.medium.com/max/1052/1*ONt5L9S_sNaLQoIoECflWQ.png)

### Installing Terraform
- Download desired Terraform version as a zipped file
- Unzip to desired location
- Open advanced system settings and environment variables
- Add path to Terraform file
- `terraform --version` to test installed correctly

### Terrafrom most used commands
- `terraform init`
- `terraform plan` checks syntax
- `terraform apply` runs main.tf
- `terraform destroy` destroys resources from main.tf

### Using Terraform with AWS
#### Securing AWS keys with Terraform
- Open advanced system settings and environment variables
- Add new variables
	- `AWS_ACCESS_KEY_ID`
	- `AWS_SECRET_ACCESS_KEY`

#### Using main.tf
- Create VPC
- Create Internet Gateway
- Create Route Table
- Create subnet for app instance
- Create subnet for db instance
- Associate route tables with created subnets
- Create app security group
- Create database security group
- Create db instance
- Create app instance
```
provider "aws"{
	region = "eu-west-1"
}

resource "aws_instance" "app_instance"{
	ami = "ami-08412dcc11680fa41"
	instance_type = "t2.micro"
	associate_public_ip_address = true

	tags = {
		Name = "eng84_jordan_terraform_app"
	}
}
```
- Run app from app instance
	- `DB_HOST=mongodb://32.34.14.X:27017/posts` change DB_HOST env variable to correct private IP for db instance
	- SSH into app instance
	- nodejs app.js
