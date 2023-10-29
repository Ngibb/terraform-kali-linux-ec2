locals {
  will_create_network          = (var.vpc_id != null || var.subnet_id != null || var.security_group_ids != null) ? false : true
  will_create_instance_profile = (var.iam_instance_profile_name != null) ? false : true
  chosen_vpc_id                = coalesce(var.vpc_id, module.vpc[0].vpc_id)
  chosen_subnet_id             = coalesce(var.subnet_id, module.vpc[0].public_subnets[0])
  chosen_security_groups       = coalesce(var.security_group_ids, [aws_security_group.allow_all_egress[0].id])
  chosen_instance_profile_name = coalesce(var.iam_instance_profile_name, aws_iam_instance_profile.ssm_core_profile[0].name)
  chosen_userdata_string       = (var.user_data_filepath != null) ? file(var.user_data_filepath) : templatefile("${path.module}/userdata.sh.tftpl", { "enable_rdp" : var.enable_rdp, "kali_password" : random_password.kali.result, "rdp_port" : var.kali_rdp_port })
}

resource "random_password" "kali" {
  length           = 16
  special          = true
  override_special = "!@#$%&*?"
}