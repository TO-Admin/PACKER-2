source "amazon-ebs" "example" {
  ami_name      = "secure-lightweight-ami"
  instance_type = "t2.micro"
  region        = "eu-west-3" # Remplace par ta région AWS
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical, propriétaire des AMIs Ubuntu
  }
  ssh_username = "ubuntu"
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
