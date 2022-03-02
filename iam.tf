resource "aws_security_group" "this" {
  name_prefix = "default"
  description = "."
  vpc_id      = aws_default_vpc.this.id
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

resource "aws_iam_instance_profile" "this" {
  name_prefix = "default"
  role        = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name_prefix = "default"
  path        = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

locals {
  ssm_policies_list = {
    ssm-core = {
      arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    }
  }
}

resource "aws_iam_policy_attachment" "this" {
  for_each = local.ssm_policies_list

  name       = each.key
  roles      = [aws_iam_role.this.name]
  policy_arn = lookup(each.value, "arn", null)
}
