# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
  allowed_account_ids = [var.aws_account_id]
}

terraform {

  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }

  backend "local" {
    path = "tfstate/terraform.local-tfstate"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "ghost-aws-deployment-bootstrap.tfstates"
  force_destroy = false

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_acl" "ux2play_una_recordings" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-dynamodb-lock-table"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
