data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ghost ubuntu 21.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.aws_account_id]
}

resource "aws_iam_instance_profile" "ux2play_instance_profile" {
  name = "ux2play-instance-profile"
  role = aws_iam_role.ux2play_instance_role.name
}

resource "aws_kms_key" "ec2_instance_kms_key" {
  description             = "EC2 Instance KMS key"
  deletion_window_in_days = 30
}

resource "aws_instance" "ghost" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.small"
  availability_zone    = "${data.aws_region.current.name}a"
  iam_instance_profile = aws_iam_instance_profile.ux2play_instance_profile.name
  key_name             = aws_key_pair.admin.key_name
  subnet_id            = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [
    aws_security_group.allow_all_outbound.id,
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_http.id,
  ]

  tags = merge(var.tags, {
    Name = "main-instance"
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami]
  }

  disable_api_termination              = "true"
  instance_initiated_shutdown_behavior = "stop"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}

# EIP
resource "aws_eip" "ghost-main" {
  instance = aws_instance.ghost.id
  vpc      = true
}
