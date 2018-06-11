provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "adam-terraform-up-and-running-state-v2"
    key            = "root/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "terraform_statelock"
  }
}
