# Terraform
## What is Terraform?

## What are the benefits of Terraform?

## Using Terraform

### Installing Terraform
- Download desired Terraform version as a zipped file
- Unzip to desired location
- Open advanced system settings and environment variables
- Add path to Terraform file
- `terraform --version` to test installed correctly

### Terrafrom most used commands

### Using Terraform with AWS

#### Securing AWS keys with Terraform
- Open advanced system settings and environment variables
- Add new variables
	- `AWS_ACCESS_KEY_ID`
	- `AWS_SECRET_ACCESS_KEY`

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
