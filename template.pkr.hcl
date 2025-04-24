source "amazon-ebs" "example" {
  ami_name      = "test4-pipeline"
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
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo add-apt-repository universe -y",
      "sudo apt-get update -y || sleep 30 && sudo apt-get update -y", 
      "sudo apt-get install fail2ban -y",
      "sudo apt-get update && sudo apt-get upgrade -y",
      "sudo apt-get install fail2ban -y",
      "sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd",
      "sudo apt-get autoremove -y && sudo apt-get clean",
    ]
  }
}

