provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-40d28157"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "adam-terraform-up-and-running-state-v2"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "terraform_statelock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    bucket         = "adam-terraform-up-and-running-state-v2"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "terraform_statelock"
  }
}
