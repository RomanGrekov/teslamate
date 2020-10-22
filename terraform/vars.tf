# Obligatory variables to pass
variable "PROJECT" {
  description = "Usaly name of GIT repo"
  default     = "teslamate"
}

variable "ADMIN_EMAIL" {
  description = "Admin email address for letsencrupt"
}

variable "AWS_REGION" {
}

variable "DOMAIN" {
  description = "Domain name for letsencrypt"
}

variable "TESLAMATE_SUBDOMAIN" {
  description = "Subdomain for teslamate itself"
}

variable "GRAFANA_SUBDOMAIN" {
  description = "Subdomain for teslamate grafana"
}

variable "BASIC_AUTH_USER" {
  description = "User to login to web site using basic auth"
}

variable "BASIC_AUTH_PASSWORD" {
  description = "Password to login to web site using basic auth"
}

variable "PATH_TO_PUBLIC_KEY" {
  description = "Path to ssh public key to have access to your EC2"
}

variable "PATH_TO_PRIV_KEY" {
  description = "Path to ssh private key to install Teslamate with ansible"
}
########################## END of obligatory vars

locals {
  project_env_name = "${var.PROJECT}-${terraform.workspace}"

  common_tags = {
    Project     = "${var.PROJECT}"
    Environment = terraform.workspace
    Name        = "${var.PROJECT}-${terraform.workspace}"
  }

}
