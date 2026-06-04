output "key_name" {
  value = aws_key_pair.backend.key_name
}

output "private_key" {
  value     = tls_private_key.backend.private_key_pem
  sensitive = true
}