data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "gitea_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "crossrt_aws"

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }

  subnet_id              = element(aws_subnet.public_subnet.*.id, 0)
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "gitea-server"
  }
}

resource "aws_eip" "eip" {
  instance         = aws_instance.gitea_server.id
  public_ipv4_pool = "amazon"
  vpc              = true
}

resource "aws_eip_association" "eip_association" {
  instance_id   = aws_instance.gitea_server.id
  allocation_id = aws_eip.eip.id
}

resource "null_resource" "first_ssh" {
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = aws_eip.eip.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/crossrt_aws.pem")
    }
  }
}

resource "null_resource" "setup" {
  depends_on = [
    null_resource.first_ssh
  ]

  triggers = {
    playbook_checksum = filesha256("setup-gitea.yml")
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_eip.eip.public_ip},' --private-key ~/.ssh/crossrt_aws.pem ./setup-gitea.yml"
  }
}
