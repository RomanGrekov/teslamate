data "aws_route53_zone" "public" {
  name         = var.DOMAIN
  private_zone = false
}

# Standard route53 DNS record for letsencrypt pointing to ec2 elastic ip
resource "aws_route53_record" "general" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.DOMAIN
  type    = "A"
  ttl     = "300"
  records = [aws_eip.teslamate.public_ip]
}

# Standard route53 DNS record for "teslamate" pointing to ec2 elastic ip
resource "aws_route53_record" "teslamate" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.TESLAMATE_SUBDOMAIN}.${var.DOMAIN}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.teslamate.public_ip]
}

output "teslamate-dns" {
  value = "https://${aws_route53_record.teslamate.fqdn}"
}

# Standard route53 DNS record for "grafana" pointing to ec2 elastic ip
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.GRAFANA_SUBDOMAIN}.${var.DOMAIN}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.teslamate.public_ip]
}

output "grafana-dns" {
  value = "https://${aws_route53_record.grafana.fqdn}"
}
