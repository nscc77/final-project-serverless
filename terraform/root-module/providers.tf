terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    

  backend "s3" {
    bucket = "serverless24b-redhat-statefile-bucket"
    key    = "memo-app.tfstate"
    region = "us-east-1"
    dynamodb_table = "serverless24b-redhat-dev-terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}