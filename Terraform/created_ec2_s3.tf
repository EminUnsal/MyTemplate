terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.39.0"
    }
  }
}

## Credentials olayini unutmamak lazim yoksa bir provider'da herhangi bir islemi yapamayiz
## Bir sekilde o izni almaliyiz

provider "aws" {
  # here region musst be specified
  region  = "us-east-1"
  # access key and secret key can be entered here
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  
}
resource "aws_instance" "first" {
    ami = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    key_name   = "First_Key"
    user_data = <<EOF
      #! /bin/bash
      yum update -y
      yum install -y yum-utils
      yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
      yum -y install terraform    
      EOF
    tags = {
      "Name" = "First-Instance-by-Terraform"   
  }
}
resource "aws_s3_bucket" "first" {
  bucket = "mybucket-by-terraform"
  # force_destroy = true    bucket dolu olsa bile silebiliriz
}