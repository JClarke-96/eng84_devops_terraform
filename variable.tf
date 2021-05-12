# variable.tf
variable "vpc_id" {
	default = "vpc-07e47e9d90d2076da"
}

variable "name" {
	default = "eng84_jordan_terraform_variable"
}

variable "webapp_ami_id" {
	default = "ami-08412dcc11680fa41"
}

variable "db_ami_id" {
	default = "ami-031892f255bddb977"
}

variable "aws_subnet" {
	default = "eng84_jordan_terraform_app"
}

variable "aws_key_name" {
	default = "eng84devops"
}

variable "aws_key_path" {
	default = "C:/Users/JClar/.ssh/eng84devops.pem"
}
