terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    

  backend "s3" {
    bucket = "terraform-state-nscc77"
    key    = "homework-project-nscc77.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = "us-east-1"
}