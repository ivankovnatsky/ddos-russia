resource "aws_default_vpc" "this" {}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.this.id]
  }
}

data "aws_security_group" "default" {
  vpc_id = aws_default_vpc.this.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}
