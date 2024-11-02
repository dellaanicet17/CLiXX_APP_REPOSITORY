# --- VPC and Subnets Configurations ---
resource "aws_vpc" "mystack_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "mystackvpc"
  }
}

# --- Public Subnets ---
resource "aws_subnet" "mystack_public_subnet1" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = var.public_az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "mystack-public-subnet1"
  }
}
resource "aws_subnet" "mystack_public_subnet2" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = var.public_az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "mystack-public-subnet2"
  }
}

# --- Private Subnets ---
resource "aws_subnet" "mystack_private_subnet1" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet1_cidr_block_webapp
  availability_zone = var.private_az_1

  tags = {
    Name = "mystack-private-subnet1-webapps"
  }
}
resource "aws_subnet" "mystack_private_subnet2" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet2_cidr_block_webapp
  availability_zone = var.private_az_2

  tags = {
    Name = "mystack-private-subnet2-webapps"
  }
}
resource "aws_subnet" "mystack_private_subnet3" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet1_cidr_block_app_db
  availability_zone = var.private_az_1

  tags = {
    Name = "mystack-private-subnet1-app-dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet4" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet2_cidr_block_app_db
  availability_zone = var.private_az_2

  tags = {
    Name = "mystack-private-subnet2-app-dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet5" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet1_cidr_block_oracle_db
  availability_zone = var.private_az_1

  tags = {
    Name = "mystack-private-subnet1-oracle_dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet6" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet2_cidr_block_oracle_db
  availability_zone = var.private_az_2

  tags = {
    Name = "mystack-private-subnet2-oracle_dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet7" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet1_cidr_block_java_db
  availability_zone = var.private_az_1

  tags = {
    Name = "mystack-private-subnet1-java-dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet8" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet2_cidr_block_java_db
  availability_zone = var.private_az_2

  tags = {
    Name = "mystack-private-subnet2-java-dbs"
  }
}
resource "aws_subnet" "mystack_private_subnet9" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet1_cidr_block_java_app
  availability_zone = var.private_az_1

  tags = {
    Name = "mystack-private-subnet1-java-apps"
  }
}
resource "aws_subnet" "mystack_private_subnet10" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.private_subnet2_cidr_block_java_app
  availability_zone = var.private_az_2

  tags = {
    Name = "mystack-private-subnet2-java-apps"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "mystack_igw" {
  vpc_id = aws_vpc.mystack_vpc.id
  
  tags = {
    Name = "mystack-internet-gateway"
  }
}

# --- NAT Gateways ---
resource "aws_nat_gateway" "mystack_nat_gw1" {
  allocation_id = aws_eip.mystack_nat_eip1.id
  subnet_id    = aws_subnet.mystack_public_subnet1.id

  tags = {
    Name = "mystack-nat-gateway1"
  }
}
resource "aws_nat_gateway" "mystack_nat_gw2" {
  allocation_id = aws_eip.mystack_nat_eip2.id
  subnet_id    = aws_subnet.mystack_public_subnet2.id

  tags = {
    Name = "mystack-nat-gateway2"
  }
}

# --- Elastic IPs for NAT Gateways ---
resource "aws_eip" "mystack_nat_eip1" {
  domain = "vpc"

  tags = {
    Name = "mystack-elasticip1"
  }
}
resource "aws_eip" "mystack_nat_eip2" {
  domain  = "vpc"

  tags = {
    Name = "mystack-elasticip2"
  }
}

# --- Public Route Tables ---
# Public Route Table 1
resource "aws_route_table" "mystack_public_rt1" {
  vpc_id = aws_vpc.mystack_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mystack_igw.id
  }

  tags = {
    Name = "mystack-public-rt1"
  }
}

# --- Route Table Associations for Public Route Table 1 ---
resource "aws_route_table_association" "mystack_public_rt1_assoc1" {
  subnet_id      = aws_subnet.mystack_public_subnet1.id
  route_table_id = aws_route_table.mystack_public_rt1.id
}


# Public Route Table 2
resource "aws_route_table" "mystack_public_rt2" {
  vpc_id = aws_vpc.mystack_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mystack_igw.id
  }
  tags = {
    Name = "mystack-public-rt2"
  }
}

# --- Route Table Associations for Public Route Table 2 ---
resource "aws_route_table_association" "mystack_public_rt2_assoc1" {
  subnet_id      = aws_subnet.mystack_public_subnet2.id
  route_table_id = aws_route_table.mystack_public_rt2.id
}

# --- Private Route Tables ---
# Private Route Table1
resource "aws_route_table" "stack_priv_rt1" {
  vpc_id = aws_vpc.mystack_vpc.id

  tags = {
    Name = "mystack-private-rt1"
  }
}

# --- Route Table Associations for Private Route Table 1 ---
resource "aws_route_table_association" "mystack_private_rt1_assoc1" {
  subnet_id      = aws_subnet.mystack_private_subnet1.id
  route_table_id = aws_route_table.mystack_private_rt1.id
}
resource "aws_route_table_association" "mystack_private_rt1_assoc2" {
  subnet_id      = aws_subnet.mystack_private_subnet3.id
  route_table_id = aws_route_table.mystack_private_rt1.id
}
resource "aws_route_table_association" "mystack_private_rt1_assoc3" {
  subnet_id      = aws_subnet.mystack_private_subnet5.id
  route_table_id = aws_route_table.mystack_private_rt1.id
}
resource "aws_route_table_association" "mystack_private_rt1_assoc4" {
  subnet_id      = aws_subnet.mystack_private_subnet7.id
  route_table_id = aws_route_table.mystack_private_rt1.id
}
resource "aws_route_table_association" "mystack_private_rt1_assoc5" {
  subnet_id      = aws_subnet.mystack_private_subnet9.id
  route_table_id = aws_route_table.mystack_private_rt1.id
}
resource "aws_route" "private_route1_nat_gw1" {
  route_table_id         = aws_route_table.mystack_private_rt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mystack_nat_gw1.id
}

# Private Route Table2
resource "aws_route_table" "mystack_private_rt2" {
  vpc_id = aws_vpc.mystack_vpc.id
  tags = {
    Name = "mystack-private-rt2"
  }
}

# --- Route Table Associations for Private Route Table2 ---
resource "aws_route_table_association" "mystack_private_rt2_assoc1" {
  subnet_id      = aws_subnet.mystack_private_subnet2.id
  route_table_id = aws_route_table.mystack_private_rt2.id
}
resource "aws_route_table_association" "mystack_private_rt2_assoc2" {
  subnet_id      = aws_subnet.mystack_private_subnet4.id
  route_table_id = aws_route_table.mystack_private_rt2.id
}
resource "aws_route_table_association" "mystack_private_rt2_assoc3" {
  subnet_id      = aws_subnet.mystack_private_subnet6.id
  route_table_id = aws_route_table.mystack_private_rt2.id
}
resource "aws_route_table_association" "mystack_private_rt2_assoc4" {
  subnet_id      = aws_subnet.mystack_private_subnet8.id
  route_table_id = aws_route_table.mystack_private_rt2.id
}
resource "aws_route_table_association" "mystack_private_rt2_assoc5" {
  subnet_id      = aws_subnet.mystack_private_subnet10.id
  route_table_id = aws_route_table.mystack_private_rt2.id
}
resource "aws_route" "private_route2_nat_gw2" {
  route_table_id         = aws_route_table.mystack_private_rt2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mystack_nat_gw2.id
}


# --- Security Groups ---
resource "aws_security_group" "mystack_bastion_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "mystack-bastion-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Administrator IP's should be alternatively used or if using SSM the Amazon IP's that are published.
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "mystack-bastion-sg"
  }
}

resource "aws_security_group" "mystack_public_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "mystack-public-sg"

  # Ingress rule to allow SSH from the bastion hosts
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.mystack_bastion_sg.id]
  }
    # Ingress rule to allow ping (ICMP) from the bastion hosts
  ingress {
    from_port   = -1  # ICMP type (-1 allows all ICMP types)
    to_port     = -1  # Same as above
    protocol    = "icmp"
    security_groups = [aws_security_group.mystack_bastion_sg.id]
  }
  #HTTP
  ingress { 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #MYSQL/AURORA
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  #NFS
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress { #ALL TRAFFIC
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "mystack-public-sg"
  }
}

resource "aws_security_group" "mystack_private_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "mystack-private-sg"

  # Ingress rule to allow SSH from the bastion hosts
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.mystack_bastion_sg.id]
  }
    # Ingress rule to allow ping (ICMP) from the bastion hosts
  ingress {
    from_port   = -1  
    to_port     = -1  
    protocol    = "icmp"
    security_groups = [aws_security_group.mystack_bastion_sg.id]
  }
 #MYSQL/AURORA
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  #NFS
  ingress { 
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  #HTTPS
  ingress { 
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.mystack_public_sg.id] 
  }
  #HTTP
  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.mystack_public_sg.id] 
  }
  egress { #ALL TRAFFIC
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mystack-private-sg"
  }
}

# --- DB Subnet Groups ---
resource "aws_db_subnet_group" "mystack_clixx_subnet_group" {
  name       = "mystack-clixx-dbsubnetgroup"
  subnet_ids = [
    aws_subnet.mystack_private_subnet1.id,
    aws_subnet.mystack_private_subnet2.id
  ]
  tags = {
    Name = "mystack-clixx-dbsubnetgroup"
  }
}

# --- EFS Setup ---
resource "aws_efs_file_system" "mystack_efs" {
  creation_token = "STACK-HA-EFS-webapps"
  performance_mode = "generalPurpose"
  encrypted        = false
  throughput_mode  = "bursting"

  tags = {
    Name = "mystack-EFS-webapps"
  }
}
resource "aws_efs_mount_target" "mystack_efs_mt1" {
  file_system_id  = aws_efs_file_system.mystack_efs.id
  subnet_id       = aws_subnet.mystack_private_subnet1.id
  security_groups = [aws_security_group.mystack_private_sg.id]
}
resource "aws_efs_mount_target" "mystack_efs_mt2" {
  file_system_id  = aws_efs_file_system.mystack_efs.id
  subnet_id       = aws_subnet.mystack_private_subnet2.id
  security_groups = [aws_security_group.mystack_private_sg.id]
}

#Load Balancer
resource "aws_lb" "mystack_lb" {
  name               = "mystack-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mystack_public_sg.id]
  subnets            = [aws_subnet.mystack_public_subnet1.id, aws_subnet.mystack_public_subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name        = "mystack-lb"
  }
}
resource "aws_instance" "bastion1" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.mystack_public_subnet1.id
  associate_public_ip_address = true
  key_name = var.key_pair_name
  security_groups = [aws_security_group.mystack_bastion_sg.id]

  tags = {
    Name = "mystack-bastion1"
  }
}
resource "aws_instance" "bastion2" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.mystack_public_subnet2.id
  associate_public_ip_address = true
  key_name = var.key_pair_name
  security_groups = [aws_security_group.mystack_bastion_sg.id]

  tags = {
    Name = "mystack-bastion2"
  }
}

# --- RDS instance ---
resource "aws_db_instance" "wordpress_db" {
  identifier              = var.db_instance_identifier
  snapshot_identifier     = var.db_snapshot_identifier
  instance_class          = var.db_instance_class
  vpc_security_group_ids  = [aws_security_group.mystack_private_sg.id]
  publicly_accessible     = false
  multi_az                = true
  skip_final_snapshot     = true

  db_subnet_group_name    = aws_db_subnet_group.mystack_clixx_subnet_group.name

  tags = {
    Name = "wordpressdbclixx"
  }
}

# --- Route 53 Record ---
resource "aws_route53_record" "clixx_alb_record" {
  zone_id = var.hosted_zone_id #DNS AWS Route 53 hosted zone id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.mystack_lb.dns_name
    zone_id                = aws_lb.mystack_lb.zone_id
    evaluate_target_health = false
  }
}

# --- User Data Template ---
data "template_file" "user_data" {
  template = file(format("%s/scripts/bootstrap.tpl", path.module))

  vars = {
    file_system_id = aws_efs_file_system.mystack_efs.id
    mount_point    = var.efs_mount_point
    record_name    = var.record_name
    region         = var.aws_region
    rds_endpoint   = var.rds_endpoint
  }
}

# --- Target Groups ----
resource "aws_lb_target_group" "mystack_clixx_tg" {
  name     = "mystack-CLIXX-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mystack_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 120
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  tags = {
    Name = "mystack-clixx-tg"
  }
}
resource "aws_lb_listener" "mystack_clixx_http_listener" {
  load_balancer_arn = aws_lb.mystack_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mystack_clixx_tg.arn
  }
}
resource "aws_lb_listener" "mystack_clixx_https_listener" {
  load_balancer_arn = aws_lb.mystack_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mystack_clixx_tg.arn
  }
}

# --- Launch Template ---
resource "aws_launch_template" "mystack_clixx_lt" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.mystack_private_sg.id]

  user_data = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.iam_instance_profile
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.launch_template_name
    }
  }
}

# --- Auto Scaling Group ---
resource "aws_autoscaling_group" "clixx_asg" {
  name                = var.autoscale_group_name
  max_size            = 4
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.mystack_private_subnet1.id, aws_subnet.mystack_private_subnet2.id] 
  target_group_arns   = [aws_lb_target_group.mystack_clixx_tg.arn]

  launch_template {
    id      = aws_launch_template.mystack_clixx_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "mystack-clixx-asg"
    propagate_at_launch = true
  }
}