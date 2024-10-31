
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "clixx_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "clixx_key.pub"
}

variable "aws_region" {
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Private Subnets
variable "priv_sub1_cidr_block_app_db" {
  type        = string
  description = "The CIDR block for the private subnet application databases"
  default     = "10.0.0.0/22"
}

variable "priv_sub2_cidr_block_app_db" {
  type        = string
  description = "The CIDR block for the private subnet application databases"
  default     = "10.0.4.0/22"
}

variable "priv_sub1_cidr_block_oracle_db" {
  type        = string
  description = "The CIDR block for the private subnet oracle databases"
  default     = "10.0.9.0/24"
}

variable "priv_sub2_cidr_block_oracle_db" {
  type        = string
  description = "The CIDR block for the private subnet oracle databases"
  default     = "10.0.10.0/24"
}

variable "priv_sub1_cidr_block_webapp" {
  type        = string
  description = "The CIDR block for the private subnet webapp servers"
  default     = "10.0.11.0/24"
}

variable "priv_sub2_cidr_block_webapp" {
  type        = string
  description = "The CIDR block for the private subnet webapp servers"
  default     = "10.0.12.0/24"
}

variable "priv_sub1_cidr_block_java_db" {
  type        = string
  description = "The CIDR block for the first private subnet for Java databases"
  default     = "10.0.13.0/26"
}

variable "priv_sub2_cidr_block_java_db" {
  type        = string
  description = "The CIDR block for the second private subnet for Java databases"
  default     = "10.0.13.64/26"
}

# Private Subnets for Java Applications
variable "priv_sub1_cidr_block_java_app" {
  type        = string
  description = "The CIDR block for the first private subnet for Java applications"
  default     = "10.0.13.128/26"
}

variable "priv_sub2_cidr_block_java_app" {
  type        = string
  description = "The CIDR block for the second private subnet for Java applications"
  default     = "10.0.13.192/26"
}

#Public Subnet
variable "pub_sub1_cidr_block" {
  type        = string
  description = "The CIDR block for the public subnet"
  default     = "10.0.14.0/25"
}

variable "pub_sub2_cidr_block" {
  type        = string
  description = "The CIDR block for an additional public subnet"
  default     = "10.0.14.128/25"
}

variable "pub_az_1" {
  type        = string
  description = "Public Availability Zone 1"
  default     = "us-east-1a"
}

variable "pub_az_2" {
  type        = string
  description = "Public Availability Zone 2"
  default     = "us-east-1b"
}

variable "priv_az_1" {
  type        = string
  description = "Private Availability Zone 1"
  default     = "us-east-1a"
}

variable "priv_az_2" {
  type        = string
  description = "Private Availability Zone 2"
  default     = "us-east-1b"
}

variable "autoscale_group_name" {
  description = "Name of the Auto Scaling group"
  default     = "CLiXX-ASG"
}

variable "vpc_priv_az_1" {
  description = "The availability zone for the private subnets."
  type        = string
  default = "us-east-1a"
}

variable "vpc_priv_az_2" {
  description = "The availability zone for the second private subnets."
  type        = string
  default = "us-east-1b"
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion instance"
  default = "ami-00f251754ac5da7f0"
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion instance"
  default = "t2.micro"
}

variable "launch_template_name" {
  description = "Name of the launch template"
  default     = "CLiXX-LT"
}


variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-00f251754ac5da7f0"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
  default     = "db.m6gd.large"
}

variable "key_pair_name" {
  description = "Key pair name for EC2 instances"
  default     = "stack_devops_kp"
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier"
  default     = "wordpressdbclixx"
}

variable "db_snapshot_identifier" {
  description = "RDS DB snapshot identifier"
  default     = "arn:aws:rds:us-east-1:043309319757:snapshot:wordpressdbclixx-ecs-snapshot-copy"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  default     = "arn:aws:acm:us-east-1:043309319757:certificate/1e2f9427-2612-4811-9eb9-682ef736ad48"
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID"
  default     = "Z022607324NJ585R59I5F"
}

variable "record_name" {
  description = "DNS record name for the load balancer"
  default     = "test.clixx-wdella.com"
}

variable "iam_instance_profile" {
  description = "IAM role for EC2 Instance deployment"
  default     = "EFS_operations"
}

variable "rds_endpoint" {
  description = "rds endpoint address for wordpress db instance"
  default     = "wordpressdbclixx.cj0yi4ywm61r.us-east-1.rds.amazonaws.com"
}

variable "efs_mount_point" {
  description = "mount point for efs"
  default     = "/var/www/html"
}

variable "db_username" {
  description = "Database username"
  default     = "wordpressuser"
}

variable "db_password" {
  description = "Database password"
  default     = "W3lcome123"
}
