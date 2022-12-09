terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.42.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  default = "ami-0b0dcb5067f052a63"
}
resource "aws_instance" "instance1" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  user_data         = file("./terraform.sh")
  key_name          = "First_Key"
  tags = {
    "Name" = "Terraform"
  }
}