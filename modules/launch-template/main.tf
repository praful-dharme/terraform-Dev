data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "backend" {

  name_prefix   = "backend-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -e

apt update -y
apt install -y nginx curl

systemctl enable nginx
systemctl start nginx

# ---- IMDSv2 token ----
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

# ---- Metadata ----
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

HOSTNAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/hostname)

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

# ---- Web page ----
cat > /var/www/html/index.html <<EOF
<html>
<head><title>EC2 Info</title></head>
<body>
  <h1>Backend Server Running on Server</h1>
  <p><b>Instance ID:</b> $INSTANCE_ID</p>
  <p><b>Hostname:</b> $HOSTNAME</p>
  <p><b>Private IP:</b> $PRIVATE_IP</p>
</body>
</html>
EOF
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "backend-server"
    }
  }
}