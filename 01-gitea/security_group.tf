locals {
  ingress_rules = [{
    name        = "HTTPS"
    port        = 443
    description = "Ingress rules for port 443"
    cidr_blocks = ["0.0.0.0/0"]
  }, {
    name        = "HTTP"
    port        = 80
    description = "Ingress rules for port 80"
    cidr_blocks = ["0.0.0.0/0"]
  }, {
    name        = "HTTP"
    port        = 3000
    description = "Ingress rules for port 3000"
    cidr_blocks = ["0.0.0.0/0"]
  }, {
    name        = "SSH"
    port        = 22
    description = "Ingress rules for port 22"
    cidr_blocks = ["175.145.249.144/32"]
  }]
}

resource "aws_security_group" "sg" {

  name        = "assessment-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.assessment_vpc.id
  egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = {
    Name = "AWS security group dynamic block"
  }

}
