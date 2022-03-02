data "template_file" "this" {
  template = file("${path.module}/user_data.sh")
  vars = {
    ENDPOINT_TO_DDOS = var.endpoint_to_ddos
    IP_TO_DDOS       = var.ip_to_ddos
    PORT_TO_DDOS     = var.port_to_ddos
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "default"
  image_id      = data.aws_ami.this.id
  instance_type = "t3a.micro"

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.this.id,
  ]

  user_data = base64encode(data.template_file.this.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
}

resource "aws_autoscaling_group" "this" {
  force_delete       = true
  capacity_rebalance = true
  desired_capacity   = 20
  max_size           = 20
  min_size           = 0
  availability_zones = data.aws_availability_zones.this.names

  instance_refresh {
    strategy = "Rolling"
  }

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }

      override {
        instance_type = "t2.micro"
      }

      override {
        instance_type = "t3.micro"
      }
    }
  }
}
