source "amazon-ebs" "tp-packer-2" {
  ami_name      = "tp-packer-2"
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
}

build {
  sources = ["source.amazon-ebs.tp-packer-2"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update && sudo apt-get upgrade -y",
      "sudo apt-get install fail2ban -y",
      "sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd",
      "sudo apt-get autoremove -y && sudo apt-get clean",
    ]
  }
}
