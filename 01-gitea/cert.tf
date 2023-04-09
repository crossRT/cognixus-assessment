resource "aws_acm_certificate" "main_cert" {
  domain_name       = "gitea.assessment-ray.xyz"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "main_cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.primary.zone_id
  ttl = 60
}

resource "aws_acm_certificate_validation" "main_cert_validate" {
  certificate_arn = aws_acm_certificate.main_cert.arn
  validation_record_fqdns = [aws_route53_record.main_cert_dns.fqdn]
}
