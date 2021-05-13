# variable.tf
variable "my_ip" {
	default = "87.80.63.166/32"
}

variable "aws_vpc" {
	default = "eng84_jordan_terraform_vpc"
}

variable "aws_ig" {
	default = "eng84_jordan_terraform_ig"
}

variable "aws_rt" {
	default = "eng84_jordan_terraform_rt"
}

variable "a_zone" {
	default = "eu-west-1b"
}

variable "app_cidr" {
	default = "32.34.1.0/24"
}

variable "aws_app" {
	default = "eng84_jordan_terraform_app"
}

variable "db_cidr" {
	default = "32.34.2.0/24"
}

variable "aws_db" {
	default = "eng84_jordan_terraform_db"
}

variable "app_sg" {
	default = "eng84_jordan_terraform_app_sg"
}

variable "db_sg" {
	default = "eng84_jordan_terraform_db_sg"
}

variable "webapp_ami_id" {
	default = "ami-08412dcc11680fa41"
}

variable "db_ami_id" {
	default = "ami-031892f255bddb977"
}

variable "aws_key_name" {
	default = "eng84devops"
}

variable "aws_key_path" {
	default = "C:/Users/JClar/.ssh/eng84devops.pem"
}
