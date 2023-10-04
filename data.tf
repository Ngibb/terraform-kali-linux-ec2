data "aws_region" "current" {}

data "template_file" "user_data" {
  template = file(coalesce(var.user_data_filepath, "${path.module}/userdata.sh"))
}

data "aws_ami" "kali" {
  owners      = ["679593333241"]
  most_recent = true
  name_regex  = "^kali-.*"

  filter {
    name   = "name"
    values = ["kali-*"]
  }

  filter {
    name   = "product-code"
    values = ["7lgvy7mt78lgoi4lant0znp5h"]
  }
}

