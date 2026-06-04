resource "tls_private_key" "backend" {

  algorithm = "RSA"

  rsa_bits = 4096
}

resource "aws_key_pair" "backend" {

  key_name = "backend-key"

  public_key = tls_private_key.backend.public_key_openssh
}