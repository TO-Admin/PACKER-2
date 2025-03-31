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
      "sudo yum install python3-devel 2to3 -y",
      "cd /tmp && curl -LO https://github.com/fail2ban/fail2ban/archive/refs/tags/1.0.2.tar.gz",
      "tar xzf 1.0.2.tar.gz && cd fail2ban-1.0.2",
      "./fail2ban-2to3 && python3 setup.py build",
      "sudo python3 setup.py install",
      "sudo cp ./build/fail2ban.service /etc/systemd/system/",
      "sudo systemctl enable fail2ban"
    ]
  }
}
