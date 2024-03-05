resource "aws_security_group" "this" {
  name_prefix = "default"
  description = "."
  vpc_id      = aws_default_vpc.this.id
}

resource "aws_security_group_rule" "ingress" {
  description       = "."
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  description       = "."
  protocol          = "all"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}
