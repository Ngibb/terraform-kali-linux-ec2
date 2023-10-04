resource "aws_instance" "kali" {
  ami                         = data.aws_ami.kali.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.kali.key_name
  associate_public_ip_address = var.associate_public_ip
  subnet_id                   = local.chosen_subnet_id
  vpc_security_group_ids      = local.chosen_security_groups
  user_data                   = base64encode(data.template_file.user_data.rendered)
  iam_instance_profile        = local.chosen_instance_profile_name
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted   = true
    volume_size = tostring(var.ebs_vol_size_gb)
  }
  tags = merge({ Name = "kali-ec2-tf" }, var.additional_tags)

}
