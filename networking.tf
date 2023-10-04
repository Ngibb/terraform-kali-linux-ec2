#tfsec:ignore:aws-ec2-no-excessive-port-access
#tfsec:ignore:aws-ec2-no-public-ingress-acl
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
module "vpc" {
  count   = local.will_create_network ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "kali-ec2-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${data.aws_region.current.name}a"]
  public_subnets = ["10.0.1.0/24"]

  public_dedicated_network_acl = true

  tags = merge(var.additional_tags)

}

resource "aws_security_group" "allow_all_egress" {
  count       = local.will_create_network ? 1 : 0
  description = "Managed by Terraform. Allow all Kali egress traffic."
  vpc_id      = local.chosen_vpc_id

  egress {
    description = "Managed by Terraform. Allow all egress traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.additional_tags)
}