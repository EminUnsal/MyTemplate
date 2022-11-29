terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.42.0"
    }
  }
}

provider "aws" {

}
resource "aws_instance" "instance1" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  user_data         = filebase64("${abspath(path.module)}/terraform.sh")
  key_name          = "First_Key"
  tags = {
    "Name" = "Terraform"
  }

}

variable "ami" {
  default = "ami-0b0dcb5067f052a63"

}