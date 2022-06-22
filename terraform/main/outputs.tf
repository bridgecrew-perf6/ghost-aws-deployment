output "ec2_public_ip" {
  value = aws_eip.ghost-main.public_ip
}

output "ec2_public_dns" {
  value = aws_eip.ghost-main.public_dns
}