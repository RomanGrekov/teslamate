
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      ec2-dns             = aws_eip.teslamate.public_dns,
      ec2-ip              = aws_eip.teslamate.public_ip,
      ec2-user            = "ubuntu",
      ec2-priv-key        = var.PATH_TO_PRIV_KEY
      aws_region          = var.AWS_REGION,
      admin_email         = var.ADMIN_EMAIL
      domain              = var.DOMAIN
      teslamate_subdomain = var.TESLAMATE_SUBDOMAIN
      grafana_subdomain   = var.GRAFANA_SUBDOMAIN
      basic_auth_user     = var.BASIC_AUTH_USER
      basic_auth_password = var.BASIC_AUTH_PASSWORD
  })
  filename = "inventory"
}
