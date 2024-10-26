# --- VPC and Subnets Configurations ---
resource "aws_vpc" "mystack_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MYSTACKVPC"
  }
}

# --- Create two Public Subnets (in Availability Zones a and b) ---
resource "aws_subnet" "mystack_subnet_pub1" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.public_subnet_cidr_block_1
  availability_zone = var.public_az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "MYSTACKPUBSUB1"
  }
}
resource "aws_subnet" "mystack_subnet_pub2" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.public_subnet_cidr_block_2
  availability_zone = var.public_az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "MYSTACKPUBSUB2"
  }
}

# --- Create two Private Subnets (in Availability Zones a and b) ---
resource "aws_subnet" "mystack_subnet_priv1" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet_cidr_block_1
  availability_zone = var.private_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1"
  }
}
resource "aws_subnet" "mystack_subnet_priv2" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = var.private_az_2

  tags = {
    Name = "MYSTACKPRIVSUB2"
  }
}

# --- Internet Gateway and Route Tables ---
resource "aws_internet_gateway" "mystack_igw" {
  vpc_id = aws_vpc.mystack_vpc.id
  
  tags = {
    Name = "MYSTACKIGW"
  }
}
resource "aws_route_table" "mystack_pub_rt" {
  vpc_id = aws_vpc.mystack_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mystack_igw.id
  }

  tags = {
    Name = "MYSTACKPUBRT"
  }
}
resource "aws_route_table_association" "mystack_pub_rt_assoc1" {
  subnet_id      = aws_subnet.mystack_subnet_pub1.id
  route_table_id = aws_route_table.mystack_pub_rt.id
}
resource "aws_route_table_association" "mystack_pub_rt_assoc2" {
  subnet_id      = aws_subnet.mystack_subnet_pub2.id
  route_table_id = aws_route_table.mystack_pub_rt.id
}
resource "aws_route_table" "mystack_priv_rt" {
  vpc_id = aws_vpc.mystack_vpc.id

  tags = {
    Name = "MYSTACKPRIVRT"
  }
}
resource "aws_route_table_association" "mystack_priv_rt_assoc1" {
  subnet_id      = aws_subnet.mystack_subnet_priv1.id
  route_table_id = aws_route_table.mystack_priv_rt.id
}
resource "aws_route_table_association" "mystack_priv_rt_assoc2" {
  subnet_id      = aws_subnet.mystack_subnet_priv2.id
  route_table_id = aws_route_table.mystack_priv_rt.id
}

# --- Security Groups ---
resource "aws_security_group" "mystack_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "MYSTACKSG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MYSTACKSG"
  }
}

resource "aws_security_group" "mystack_sg_priv" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "MYSTACKSGPRIV"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MYSTACKSGPRIV"
  }
}

# --- DB Subnet Group ---
resource "aws_db_subnet_group" "mystack_db_subnet_group" {
  name       = "mystack-db-subnet-group"
  subnet_ids = [
    aws_subnet.mystack_subnet_priv1.id,
    aws_subnet.mystack_subnet_priv2.id
  ]
  tags = {
    Name = "MYSTACKDBSUBNETGROUP"
  }
}

# --- RDS instance ---
resource "aws_db_instance" "wordpress_db" {
  identifier              = var.db_instance_identifier
  snapshot_identifier     = var.db_snapshot_identifier
  instance_class          = var.db_instance_class
  vpc_security_group_ids  = [aws_security_group.mystack_sg_priv.id]  
  availability_zone       = var.private_az_1
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  allocated_storage        = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = var.db_username
  password                = var.db_password
  # Validate VPC ID
  db_subnet_group_name    = aws_db_subnet_group.mystack_db_subnet_group.name

  tags = {
    Name = "wordpressdbclixx"
  }
}

# --- EFS Setup ---
resource "aws_efs_file_system" "clixx_efs" {
  creation_token = "CLiXX-EFS"
  performance_mode = "generalPurpose"
  encrypted        = false
  throughput_mode  = "bursting"

  tags = {
    Name = "CLiXX-EFS"
  }
}
resource "aws_efs_mount_target" "clixx_mt_priv1" {
  file_system_id  = aws_efs_file_system.clixx_efs.id
  subnet_id       = aws_subnet.mystack_subnet_priv1.id
  security_groups = [aws_security_group.mystack_sg_priv.id]
}
resource "aws_efs_mount_target" "clixx_mt_priv2" {
  file_system_id  = aws_efs_file_system.clixx_efs.id
  subnet_id       = aws_subnet.mystack_subnet_priv2.id
  security_groups = [aws_security_group.mystack_sg_priv.id]
}

# --- Load Balancer and Target Groups ---
resource "aws_lb_target_group" "clixx_tg" {
  name     = "CLiXX-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mystack_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 4
    timeout             = 30
    interval            = 120
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  tags = {
    Name = "CLiXX-TG"
  }
}
resource "aws_lb" "clixx_lb" {
  name               = "CLiXX-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mystack_sg.id]
  subnets            = [aws_subnet.mystack_subnet_pub1.id, aws_subnet.mystack_subnet_pub2.id]

  enable_deletion_protection = false

  tags = {
    Name        = "CLiXX-LB"
    Environment = "dev"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.clixx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx_tg.arn
  }
}
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.clixx_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx_tg.arn
  }
}

# --- Route 53 Record ---
resource "aws_route53_record" "clixx_alb_record" {
  zone_id = var.hosted_zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.clixx_lb.dns_name
    zone_id                = aws_lb.clixx_lb.zone_id  #Z04517273VCLIDX9UEQR7 
    evaluate_target_health = true
  }
}

# --- User Data Template ---
data "template_file" "user_data" {
  template = file(format("%s/scripts/bootstrap.tpl", path.module))

  vars = {
    file_system_id = aws_efs_file_system.clixx_efs.id
    mount_point    = var.efs_mount_point
    record_name    = var.record_name
    region         = var.aws_region
    rds_endpoint   = var.rds_endpoint
  }
}

# --- Launch Template ---
resource "aws_launch_template" "clixx_lt" {
  name          = "CLiXX-LT"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.mystack_sg.id]
  user_data = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "CLiXX-LT"
    }
  }
}

# --- Auto Scaling Group ---
resource "aws_autoscaling_group" "clixx_asg" {
  name                = "CLiXX-ASG"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.mystack_subnet_pub1.id, aws_subnet.mystack_subnet_pub2.id] 
  target_group_arns   = [aws_lb_target_group.clixx_tg.arn]
  health_check_type          = "EC2"
  health_check_grace_period  = 300

  launch_template {
    id      = aws_launch_template.clixx_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "CLiXX-ASG"
    propagate_at_launch = true
  }
}