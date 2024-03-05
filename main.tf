resource "aws_key_pair" "this" {
  key_name   = "default"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkgihzaWgJ2viRc/ijpI+2EP28tXR/vLO6KbEKVjYYxfz/+/dIYI/hs6+GoOg+lYfddy8GrEM5ifwXfwtk7Idie10HHTNMmH33RE+uofEkJjMWJF9FaMh5YD8tVGdH9SmIS6Qgo1/ct00VhUmVMfhkOwuUtc+4ibgMO97P3R1h/fKGOOxMRzK43SkbJ0Othm/e4lTjTkRN61lPAPOlKIyqycPbECa+a+tw6h5bkm17Y9NdaboAoopEdSWh+hDAxHnt4XdlMZfivO4zIQKeony4rSSds9mQ7+DQHnWB3Fm0t9JMPV2APwPQ/RPXkJWvjfMVDhCLR8ya9CN5IgBNPr2hGcfydNzAib0NO3w7KrJ6+0bQeLjIw9+b4cCPEnLvJrDJjf5rq3tNWfo9juKWzeV+3wJ+ij7GmA61s2vtwehVGQpUkIlY8zUwsY1vaSMXptFgnE66SMwXEB6WByckeKng/g612nak3VRW28ishgfd1tpM2acB9ShtKJekSzLrik0= ivan@xps"
}

data "template_file" "this" {
  template = file("${path.module}/user_data.sh")
  vars = {
    ENDPOINT_TO_DDOS = var.endpoint_to_ddos
    IP_TO_DDOS       = var.ip_to_ddos
    PORT_TO_DDOS     = var.port_to_ddos
  }
}

resource "aws_launch_template" "this" {
  name_prefix = "default"
  # NixOS-21.11.333823.96b4157790f-x86_64-linux
  image_id      = "ami-0fcf28c07e86142c5"
  instance_type = "t3a.small"

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.this.id,
  ]

  key_name = aws_key_pair.this.key_name

  # user_data = base64encode(data.template_file.this.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
}

resource "aws_autoscaling_group" "this" {
  force_delete       = true
  capacity_rebalance = true
  desired_capacity   = 1
  max_size           = 1
  min_size           = 0
  availability_zones = data.aws_availability_zones.this.names

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # instance_refresh {
  #   strategy = "Rolling"
  # }

  # mixed_instances_policy {
  #   instances_distribution {
  #     spot_allocation_strategy = "lowest-price"
  #   }

  #   launch_template {
  #     launch_template_specification {
  #       launch_template_id = aws_launch_template.this.id
  #       version            = "$Latest"
  #     }

  #     override {
  #       instance_type = "t2.small"
  #     }
  #   }
  # }
}
