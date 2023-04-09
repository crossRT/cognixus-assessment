resource "aws_route53_zone" "primary" {
  comment       = "cognixus assessment"
  force_destroy = false
  name          = "assessment-ray.xyz"

  tags = {
    "project" = "cognixus"
  }
}

resource "aws_route53_record" "gitea" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "gitea.assessment-ray.xyz"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.application_loan_balancer.dns_name]
}
