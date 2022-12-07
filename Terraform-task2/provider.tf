terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.43.0"
    }
  }
  backend "s3" {
    bucket = "terraform-vthomas"
    key    = "files/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
