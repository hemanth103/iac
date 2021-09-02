terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "hemanth-demo" {
  cidr_block       = "10.400.0.0/16"

  tags = {
    Name = "terraform-demo"
    Org = "Development-box"
    Apps = "test_cec"
  }
}
