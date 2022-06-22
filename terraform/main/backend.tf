terraform {
  backend "s3" {
    bucket         = "ghost-aws-deployment-bootstrap.tfstates"
    key            = "main/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-dynamodb-lock-table"
  }
}
