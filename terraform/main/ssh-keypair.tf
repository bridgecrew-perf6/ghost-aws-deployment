resource "aws_key_pair" "admin" {
  key_name   = "ghost-admin-key"
  public_key = var.admin_ssh_key
}
