data "aws_region" "current" {}

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

