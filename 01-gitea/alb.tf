resource "aws_lb_target_group" "target_group" {
  name        = "TargetGroup"
  port        = 3000
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.assessment_vpc.id
}

resource "aws_alb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.gitea_server.id
}

resource "aws_lb" "application_loan_balancer" {
  name               = "gitea-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id, ]
  subnets            = aws_subnet.public_subnet.*.id
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.application_loan_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   type = "forward"
  #   target_group_arn = aws_lb_target_group.target_group.arn
  # }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end_https" {
  load_balancer_arn = aws_lb.application_loan_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.main_cert.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# resource "aws_lb_listener_rule" "static" {
#   listener_arn = aws_lb_listener.front_end_http.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }

#   condition {
#     host_header {
#       values = ["gitea.crossrt.me"]
#     }
#   }
# }

resource "aws_lb_listener_certificate" "my-certificate" {
  listener_arn = aws_lb_listener.front_end_https.arn
  certificate_arn = aws_acm_certificate.main_cert.arn
}
