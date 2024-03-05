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
