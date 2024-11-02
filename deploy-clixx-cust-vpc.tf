# --- VPC and Subnets Configurations ---
resource "aws_vpc" "mystack_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MYSTACKVPC"
  }
}

# --- Public Subnets ---
resource "aws_subnet" "stack_subnet1_pub" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.pub_sub1_cidr_block
  availability_zone = var.pub_az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "MYSTACKPUBSUB1"
  }
}

resource "aws_subnet" "stack_subnet2_pub" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.pub_sub2_cidr_block
  availability_zone = var.pub_az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "MYSTACKPUBSUB2"
  }
}

# --- Private Subnets ---
resource "aws_subnet" "stack_subnet_priv1_webapp" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub1_cidr_block_webapp
  availability_zone = var.priv_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1-WEBAPP"
  }
}

resource "aws_subnet" "stack_subnet_priv2_webapp" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub2_cidr_block_webapp
  availability_zone = var.priv_az_2

  tags = {
    Name = "SMYSTACKPRIVSUB2-WEBAPP"
  }
}

resource "aws_subnet" "stack_subnet_priv1_app_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub1_cidr_block_app_db
  availability_zone = var.priv_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1-APP-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv2_app_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub2_cidr_block_app_db
  availability_zone = var.priv_az_2

  tags = {
    Name = "MYSTACKPRIVSUB2-APP-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv1_oracle_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub1_cidr_block_oracle_db
  availability_zone = var.priv_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1-ORACLE-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv2_oracle_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub2_cidr_block_oracle_db
  availability_zone = var.priv_az_2

  tags = {
    Name = "MYSTACKPRIVSUB2-ORACLE-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv1_java_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub1_cidr_block_java_db
  availability_zone = var.priv_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1-JAVA-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv2_java_db" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub2_cidr_block_java_db
  availability_zone = var.priv_az_2

  tags = {
    Name = "MYSTACKPRIVSUB2-JAVA-DB"
  }
}

resource "aws_subnet" "stack_subnet_priv1_java_app" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub1_cidr_block_java_app
  availability_zone = var.priv_az_1

  tags = {
    Name = "MYSTACKPRIVSUB1-JAVA-APP"
  }
}

resource "aws_subnet" "stack_subnet_priv2_java_app" {
  vpc_id            = aws_vpc.mystack_vpc.id
  cidr_block        = var.priv_sub2_cidr_block_java_app
  availability_zone = var.priv_az_2

  tags = {
    Name = "MYSTACKPRIVSUB2-JAVA-APP"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "stack_igw" {
  vpc_id = aws_vpc.mystack_vpc.id
  
  tags = {
    Name = "MYSTACKIGW"
  }
}

# --- NAT Gateways ---
resource "aws_nat_gateway" "stack_nat_gw1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id    = aws_subnet.stack_subnet1_pub.id

  tags = {
    Name = "MYSTACKNAT-GW1"
  }
}

resource "aws_nat_gateway" "stack_nat_gw2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id    = aws_subnet.stack_subnet2_pub.id

  tags = {
    Name = "MYSTACKNAT-GW2"
  }
}

# --- Elastic IPs for NAT Gateways ---
resource "aws_eip" "nat_eip1" {
  domain = "vpc"

  tags = {
    Name = "MYSTACKNAT-EIP1"
  }
}

resource "aws_eip" "nat_eip2" {
  domain  = "vpc"

  tags = {
    Name = "MYSTACKNAT-EIP2"
  }
}

# --- Public Route Tables ---
# Public Route Table 1
resource "aws_route_table" "stack_pub_rt1" {
  vpc_id = aws_vpc.mystack_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stack_igw.id
  }

  tags = {
    Name = "MYSTACKPUB-RT1"
  }
}

# --- Route Table Associations for Public Route Table 1 ---
resource "aws_route_table_association" "stack_pub_rt1_assoc1" {
  subnet_id      = aws_subnet.stack_subnet1_pub.id
  route_table_id = aws_route_table.stack_pub_rt1.id
}

# Public Route Table 2
resource "aws_route_table" "stack_pub_rt2" {
  vpc_id = aws_vpc.mystack_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stack_igw.id
  }

  tags = {
    Name = "MYSTACKPUB-RT2"
  }
}
# --- Route Table Associations for Public Route Table 2 ---
resource "aws_route_table_association" "stack_pub_rt2_assoc1" {
  subnet_id      = aws_subnet.stack_subnet2_pub.id
  route_table_id = aws_route_table.stack_pub_rt2.id
}

# --- Private Route Tables ---
# Private Route Table1

resource "aws_route_table" "stack_priv_rt1" {
  vpc_id = aws_vpc.mystack_vpc.id

  tags = {
    Name = "MYSTACKPRIV-RT1"
  }
}

# --- Route Table Associations for Private Route Table 1 ---
resource "aws_route_table_association" "stack_priv_rt1_assoc1" {
  subnet_id      = aws_subnet.stack_subnet_priv1_webapp.id
  route_table_id = aws_route_table.stack_priv_rt1.id
}

resource "aws_route_table_association" "stack_priv_rt1_assoc2" {
  subnet_id      = aws_subnet.stack_subnet_priv1_app_db.id
  route_table_id = aws_route_table.stack_priv_rt1.id
}

resource "aws_route_table_association" "stack_priv_rt1_assoc3" {
  subnet_id      = aws_subnet.stack_subnet_priv1_oracle_db.id
  route_table_id = aws_route_table.stack_priv_rt1.id
}

resource "aws_route_table_association" "stack_priv_rt1_assoc4" {
  subnet_id      = aws_subnet.stack_subnet_priv1_java_db.id
  route_table_id = aws_route_table.stack_priv_rt1.id
}

resource "aws_route_table_association" "stack_priv_rt1_assoc5" {
  subnet_id      = aws_subnet.stack_subnet_priv1_java_app.id
  route_table_id = aws_route_table.stack_priv_rt1.id
}

resource "aws_route" "private_route1_nat_gw1" {
  route_table_id         = aws_route_table.stack_priv_rt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.stack_nat_gw1.id
}

# Private Route Table2
resource "aws_route_table" "stack_priv_rt2" {
  vpc_id = aws_vpc.mystack_vpc.id

  tags = {
    Name = "MYSTACKPRIV-RT2"
  }
}

# --- Route Table Associations for Private Route Table2 ---
resource "aws_route_table_association" "stack_priv_rt2_assoc1" {
  subnet_id      = aws_subnet.stack_subnet_priv2_webapp.id
  route_table_id = aws_route_table.stack_priv_rt2.id
}

resource "aws_route_table_association" "stack_priv_rt2_assoc2" {
  subnet_id      = aws_subnet.stack_subnet_priv2_app_db.id
  route_table_id = aws_route_table.stack_priv_rt2.id
}

resource "aws_route_table_association" "stack_priv_rt2_assoc3" {
  subnet_id      = aws_subnet.stack_subnet_priv2_oracle_db.id
  route_table_id = aws_route_table.stack_priv_rt2.id
}

resource "aws_route_table_association" "stack_priv_rt2_assoc4" {
  subnet_id      = aws_subnet.stack_subnet_priv2_java_db.id
  route_table_id = aws_route_table.stack_priv_rt2.id
}

resource "aws_route_table_association" "stack_priv_rt2_assoc5" {
  subnet_id      = aws_subnet.stack_subnet_priv2_java_app.id
  route_table_id = aws_route_table.stack_priv_rt2.id
}

resource "aws_route" "private_route2_nat_gw2" {
  route_table_id         = aws_route_table.stack_priv_rt2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.stack_nat_gw2.id
}


# --- Security Groups ---
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "MYSTACKBASTION-SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ##########
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MYSTACKBASTION-SG"
  }
}

resource "aws_security_group" "stack_pub_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "MYSTACKPUB-SG"

  # Ingress rule to allow SSH from the bastion hosts
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
    # Ingress rule to allow ping (ICMP) from the bastion hosts
  ingress {
    from_port   = -1  # ICMP type (-1 allows all ICMP types)
    to_port     = -1  # Same as above
    protocol    = "icmp"
    security_groups = [aws_security_group.bastion_sg.id]
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
    Name = "MYSTACKPUB-SG"
  }
}

resource "aws_security_group" "stack_priv_sg" {
  vpc_id = aws_vpc.mystack_vpc.id
  name   = "MYSTACKPRIV-SG"

  # Ingress rule to allow SSH from the bastion hosts
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
    # Ingress rule to allow ping (ICMP) from the bastion hosts
  ingress {
    from_port   = -1  # ICMP type (-1 allows all ICMP types)
    to_port     = -1  # Same as above
    protocol    = "icmp"
    security_groups = [aws_security_group.bastion_sg.id]
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
    security_groups = [aws_security_group.stack_pub_sg.id] 
  }
  #HTTP
  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.stack_pub_sg.id] 
  }

  egress { #ALL TRAFFIC
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MYSTACKPRIV-SG"
  }
}



# --- DB Subnet Groups ---
resource "aws_db_subnet_group" "stack_webapp_subnet_group" {
  name       = "stack-ha-vpc-tf-webapp-dbsubnetgroup"
  subnet_ids = [
    aws_subnet.stack_subnet_priv1_webapp.id,
    aws_subnet.stack_subnet_priv2_webapp.id
  ]

  tags = {
    Name = "MYSTACK-WEBAPP-DBSUBNETGROUP"
  }
}

resource "aws_db_subnet_group" "stack_app_db_subnet_group" {
  name       = "stack-ha-vpc-tf-app_db-dbsubnetgroup"
  subnet_ids = [
    aws_subnet.stack_subnet_priv1_app_db.id,
    aws_subnet.stack_subnet_priv2_app_db.id
  ]

  tags = {
    Name = "MYSTACK-APP_DB-DBSUBNETGROUP"
  }
}

resource "aws_db_subnet_group" "stack_oracle_db_subnet_group" {
  name       = "stack-ha-vpc-tf-oracle_db-dbsubnetgroup"
  subnet_ids = [
    aws_subnet.stack_subnet_priv1_oracle_db.id,
    aws_subnet.stack_subnet_priv2_oracle_db.id
  ]

  tags = {
    Name = "MYSTACK-ORACLE_DB-DBSUBNETGROUP"
  }
}

resource "aws_db_subnet_group" "stack_java_db_subnet_group" {
  name       = "stack-ha-vpc-tf-java_db-dbsubnetgroup"
  subnet_ids = [
    aws_subnet.stack_subnet_priv1_java_db.id,
    aws_subnet.stack_subnet_priv2_java_db.id
  ]

  tags = {
    Name = "MYSTACK-JAVA_DB-DBSUBNETGROUP"
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

resource "aws_efs_mount_target" "stack_efs_mt1_webapp" {
  file_system_id  = aws_efs_file_system.clixx_efs.id
  subnet_id       = aws_subnet.stack_subnet_priv1_webapp.id
  security_groups = [aws_security_group.stack_priv_sg.id]
}
resource "aws_efs_mount_target" "stack_efs_mt2_webapp" {
  file_system_id  = aws_efs_file_system.clixx_efs.id
  subnet_id       = aws_subnet.stack_subnet_priv2_webapp.id
  security_groups = [aws_security_group.stack_priv_sg.id]
}

#Load Balancer
resource "aws_lb" "stack_lb" {
  name               = "CLiXX-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stack_pub_sg.id]
  subnets            = [aws_subnet.stack_subnet1_pub.id, aws_subnet.stack_subnet2_pub.id]

  enable_deletion_protection = false

  tags = {
    Name        = "CLiXX-LB"
  }
}

resource "aws_instance" "bastion1" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.stack_subnet1_pub.id
  associate_public_ip_address = true
  key_name = var.key_pair_name
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "MYSTACK-BASTION1"
  }
}

resource "aws_instance" "bastion2" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.stack_subnet2_pub.id
  associate_public_ip_address = true
  key_name = var.key_pair_name
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "MYSTACK-BASTION2"
  }
}

# --- RDS instance ---
resource "aws_db_instance" "wordpress_db" {
  identifier              = var.db_instance_identifier
  snapshot_identifier     = var.db_snapshot_identifier
  instance_class          = var.db_instance_class
  vpc_security_group_ids  = [aws_security_group.stack_priv_sg.id]
  publicly_accessible     = false
  multi_az                = true
  skip_final_snapshot     = true

  db_subnet_group_name    = aws_db_subnet_group.stack_webapp_subnet_group.name

  tags = {
    Name = "wordpressdbclixx"
  }
}

# --- Route 53 Record with Geolocation Routing ---
resource "aws_route53_record" "clixx_alb_record" {
  zone_id = var.hosted_zone_id   # DNS AWS Route 53 hosted zone id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.stack_lb.dns_name
    zone_id                = aws_lb.stack_lb.zone_id
    evaluate_target_health = false
  }

  # Specify geolocation routing policy
  geolocation_routing_policy {
    continent = "NA"  # Example: Route traffic from North America
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

# --- Target Groups ----
resource "aws_lb_target_group" "clixx_tg" {
  name     = "CLIXX-TG"
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
    Name = "CLIXX-TG"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.stack_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx_tg.arn
  }
}
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.stack_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx_tg.arn
  }
}

# --- Launch Template ---
resource "aws_launch_template" "clixx_lt" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.stack_priv_sg.id]

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
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.stack_subnet_priv1_webapp.id, aws_subnet.stack_subnet_priv2_webapp.id] 
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
