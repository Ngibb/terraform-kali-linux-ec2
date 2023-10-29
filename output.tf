output "kali_instance_id" {
  value = aws_instance.kali.id
}

output "kali_private_key_openssh" {
  value     = tls_private_key.kali.private_key_openssh
  sensitive = true
}

output "ssm_start_session_command" {
  value = "aws ssm start-session --target ${aws_instance.kali.id}"
}

output "start_rdp_port_forward_command" {
  value = var.priv_key_directory == null ? "Set the 'priv_key_directory' variable." : "aws ssm start-session --target ${aws_instance.kali.id} --document-name AWS-StartPortForwardingSession --parameters localPortNumber=${var.local_rdp_port},portNumber=${var.kali_rdp_port}"
}

output "ssh_command" {
  value = var.priv_key_directory == null ? "Set the 'priv_key_directory' variable." : "ssh -X -i ${local_file.kali_priv_key[0].filename} kali@${aws_instance.kali.id}"
}

output "kali_password" {
  value     = random_password.kali.result
  sensitive = true
}
