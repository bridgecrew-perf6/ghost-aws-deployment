variable "allowed_cidr_block" {
  description = "Allowed CIRDs for external access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "All tags"
  type        = object({})
  default = {
    Name          = "Ghost"
    Environment   = "production"
    ProvisionedBy = "terraform"
  }
}

variable "aws_account_id" {
  description = "AWS account ID we're running on"
  type = string
}

variable "admin_ssh_key" {
  description = "SSH key used to connect to a Ghost EC2 instance"
  type = string
  default = ""
}