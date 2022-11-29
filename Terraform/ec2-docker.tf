# Please change the key_name and your config file 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.57.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

variable "secgr-dynamic-ports" {
  default = [22, 80, 443, 8080]
}

variable "instance-type" {
  default   = "t2.micro"
  sensitive = true
}

variable "key-name" {
  default = "xxxxxxxx"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH-HTTP-HTTPS inbound traffic"

  dynamic "ingress" {
    for_each = var.secgr-dynamic-ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = "terraform"
  tags = {
    Name = "Docker-engine-josh"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              # install docker-compose
              curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
              -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
	            EOF
}

output "public-ip-address" {
  value = aws_instance.tf-ec2.public_ip
}

output "ssh-connect-command" {
  value = "ssh -i ~/.ssh/${var.key-name}.pem ec2-user@${aws_instance.tf-ec2.public_ip}"
}
