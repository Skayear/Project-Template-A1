resource "tls_private_key" "key_gen" {  
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_s3_bucket_object" "private_key" {  
  bucket  = var.ssh_bucket.id
  key     = var.ssh_key
  content = tls_private_key.key_gen.private_key_openssh
}

resource "aws_key_pair" "key" {  
  key_name   = "${var.env_full_name}-key"
  public_key = tls_private_key.key_gen.public_key_openssh
}

resource "aws_autoscaling_group" "ecs_group" { 
  name                = "${var.env_full_name}-as-group"
  vpc_zone_identifier = var.subnet_ids

  min_size                  = var.ec2_min_size
  max_size                  = var.ec2_max_size
  desired_capacity          = var.ec2_desired_capacity
  health_check_grace_period = 0
  launch_configuration      = aws_launch_configuration.ec_instance.name

  tag {
    key                 = "Name"
    value               = "${var.env_full_name}-ecs"
    propagate_at_launch = true
  }
 
}
 
resource "aws_iam_instance_profile" "ecs_instance" { 
  name = "${var.env_full_name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}
 
resource "aws_iam_role" "ecs_instance" { 
  name               = "${var.env_full_name}-ecs-instance"
  assume_role_policy = templatefile("${path.module}/policies/instance-role-trust-policy.json",{ecs_cluster_name   = var.cluster_name })
}

resource "aws_iam_role_policy" "ecs_instance" { 
  name   = "${var.env_full_name}-ecs-instance-role"
  role   = aws_iam_role.ecs_instance.name
  policy = templatefile("${path.module}/policies/instance-profile-policy.json",{ecs_cluster_name   = var.cluster_name })
}

resource "aws_launch_configuration" "ec_instance" { 
  security_groups      = concat([aws_security_group.ec2_security_group.id], var.aux_access_sg)
  key_name             = aws_key_pair.key.key_name
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_instance.name
  user_data            = templatefile("${path.module}/user_data/amzl-user-data.tpl",{ecs_cluster_name   = var.cluster_name })

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.ec2_security_group]
}

resource "aws_security_group" "ec2_security_group" { 
  name = "${var.env_full_name}-sg"
  description = "Security group for ec2 created by ecs"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "ssh access group"
    from_port = 22      
    to_port = 22
    protocol = "tcp"  
  }

   ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "dynamic port access group"
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]    
  }

}