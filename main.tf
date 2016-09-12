# Create the ECS Cluster
resource "aws_ecs_cluster" "name" {
  name = "${lookup(var.cluster_name, var.environment)}"
}

# Create a security group
resource "aws_security_group" "ecs" {
  name        = "ecs_${var.environment}"
  description = "Allows all access from VPC and SSH from office"
  vpc_id      = "${lookup(var.vpc_id, var.environment)}"

  # Allow SSH access from everywhere (Update this if required)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow access from VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${split(",", lookup(var.vpc_cidr_blocks, var.environment))}"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a launch configuration for the ECS EC2 instances
resource "aws_launch_configuration" "ecs" {
  name                 = "ecs-${lookup(var.cluster_name, var.environment)}"
  image_id             = "${lookup(var.ami, var.region)}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${lookup(var.iam_instance_profile, var.environment)}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  user_data            = "#!/bin/bash\nyum install -y -q aws-cli && aws s3 cp s3://ecs/ecs.config.template /etc/ecs/ecs.config.template && sed \"s/__CLUSTERNAME__/${lookup(var.cluster_name, var.environment)}/g\" /etc/ecs/ecs.config.template > /etc/ecs/ecs.config"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
  }
}

# Create an auto-scaling group for the EC2 ECS instances
resource "aws_autoscaling_group" "ecs-cluster" {
  availability_zones        = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier       = ["${split(",", lookup(var.subnet_ids, var.environment))}"]
  name                      = "ecs-${lookup(var.cluster_name, var.environment)}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.ecs.name}"
  health_check_grace_period = "${var.health_check_grace_period}"

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${lookup(var.instance_name_prefix, var.environment)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "role"
    value               = "ecs"
    propagate_at_launch = true
  }
}
