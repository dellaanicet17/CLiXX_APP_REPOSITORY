#variable "AWS_ACCESS_KEY" {}

#variable "AWS_SECRET_KEY" {}

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

variable "public_subnet_cidr_block_1" {
  type        = string
  description = "The CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_block_2" {
  type        = string
  description = "The CIDR block for the second public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_block_1" {
  type        = string
  description = "The CIDR block for the first private subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_block_2" {
  type        = string
  description = "The CIDR block for the second private subnet"
  default     = "10.0.4.0/24"
}

variable "public_az_1" {
  type        = string
  description = "Availability Zone for the first public subnet"
  default     = "us-east-1a"
}

variable "public_az_2" {
  type        = string
  description = "Availability Zone for the second public subnet"
  default     = "us-east-1b"
}

variable "private_az_1" {
  type        = string
  description = "Availability Zone for the first private subnet"
  default     = "us-east-1a"
}

variable "private_az_2" {
  type        = string
  description = "Availability Zone for the second private subnet"
  default     = "us-east-1b"
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
