terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1" // Tokyo
}

resource "aws_instance" "app_server" {
  ami           = "ami-0590f3a1742b17914"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraformProvisionDemo"
  }
}