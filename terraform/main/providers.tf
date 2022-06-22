# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"

  allowed_account_ids = [var.aws_account_id]
}
