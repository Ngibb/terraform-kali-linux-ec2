resource "tls_private_key" "kali" {
  algorithm = "RSA"
}

resource "aws_key_pair" "kali" {
  key_name_prefix = "kali_"
  public_key      = tls_private_key.kali.public_key_openssh
  tags            = merge(var.additional_tags)
}

resource "local_file" "kali_priv_key" {
  count           = var.priv_key_directory != null ? 1 : 0
  content         = tls_private_key.kali.private_key_openssh
  filename        = "${trimsuffix(var.priv_key_directory, "/")}/${aws_key_pair.kali.id}_priv_key"
  file_permission = "0400"
}