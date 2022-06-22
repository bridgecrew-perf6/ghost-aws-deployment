variable "region" {
  type    = string
  default = "eu-north-1"
}

data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/*ubuntu-*-21.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.region}"
}

source "amazon-ebs" "ux2play" {
  skip_create_ami             = false
  ami_name                    = "ghost ubuntu 21.04 (Packer {{isotime \"2006-01-02-15-04\"}} UTC)"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  region                      = "${var.region}"
  source_ami                  = "${data.amazon-ami.ubuntu.id}"
  temporary_key_pair_type     = "rsa"
  ssh_username                = "ubuntu"
  encrypt_boot                = true
}

build {
  sources = ["source.amazon-ebs.ux2play"]

  provisioner "ansible" {
    playbook_file = "./ansible/provision.yml"
    roles_path    = "./ansible/roles"
    use_proxy     = false
  }
}
