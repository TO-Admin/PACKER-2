source "amazon-ebs" "example" {
  ami_name      = "test5-pipeline"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  # ssh_keypair_name        = "packer_key"
  # ssh_private_key_file    = "~/.ssh/packer_key.pem"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

build {
  sources = ["source.amazon-ebs.tp-packer"]
  provisioner "ansible" {
    playbook_file = "playbook.yml"
    user = "ec2-user"
    use_sftp = true
    sftp_command = "/usr/libexec/openssh/sftp-server -e"
  }
}

