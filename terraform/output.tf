output "region" {
  value = var.AWS_REGION
}

output "server_ip" {
  value = aws_eip.teslamate.public_ip
}
