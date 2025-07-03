# ec2.tf
resource "aws_launch_template" "webapp" {
  name_prefix   = "webapp-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(file("../backend/user_data.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}

resource "aws_autoscaling_group" "webapp_asg" {
  name                      = "webapp-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.webapp.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.webapp_tg.arn]
  health_check_type = "EC2"
  tag {
    key                 = "Name"
    value               = "WebAppInstance"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow traffic from ALB"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}