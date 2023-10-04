terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
provider "aws" {
  default_tags {
    tags = {
      managed_by       = "Terraform"
      terraform_module = "kali-ec2-terraform"
    }
  }
}