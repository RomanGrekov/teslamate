########################
# server role
########################
resource "aws_iam_role" "teslamate" {
  name               = "${local.project_env_name}-teslamate"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags               = local.common_tags
}

resource "aws_iam_instance_profile" "teslamate" {
  name = local.project_env_name
  role = aws_iam_role.teslamate.name
}

# SMB instance
resource "aws_key_pair" "sshkey" {
  key_name   = "${local.project_env_name}-key"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
  tags       = local.common_tags
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #filter {
  #  name   = "root-device-type"
  #  values = ["instance-store"]
  #}
}
########################
# Main instance
########################
resource "aws_instance" "teslamate" {
  #ami                    = data.aws_ami.ubuntu.id
  ami                    = "ami-0209a3524a56ed792"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.sshkey.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.teslamate.name
  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  depends_on = [aws_vpc.main,
  aws_internet_gateway.main-gw]

  tags = merge(
    local.common_tags,
    { Name = "${local.project_env_name}-teslamate" }
  )
}

resource "aws_eip" "teslamate" {
  instance = aws_instance.teslamate.id
  vpc      = true
  tags = merge(
    local.common_tags,
    { Name = "${local.project_env_name}-teslamate" }
  )
}
