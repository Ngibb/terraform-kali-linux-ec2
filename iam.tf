resource "aws_iam_instance_profile" "ssm_core_profile" {
  count       = local.will_create_instance_profile ? 1 : 0
  name_prefix = "KaliSSMCoreInstanceProfile-"
  role        = aws_iam_role.ssm_core_role[0].name
  tags        = merge(var.additional_tags)
}

resource "aws_iam_role" "ssm_core_role" {
  count               = local.will_create_instance_profile ? 1 : 0
  name_prefix         = "KaliSSMCoreRole-"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.ecs_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  tags                = merge(var.additional_tags)
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}