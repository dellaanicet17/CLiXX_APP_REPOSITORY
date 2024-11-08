# outputs.tf

output "Bastion_security_group_id" {
  description = "Security Group ID for the application"
  value       = aws_security_group.bastion_sg.id
}

output "PUBLIC_security_group_id" {
  description = "Security Group ID for the application"
  value       = aws_security_group.stack_pub_sg.id
}

output "Private_security_group_id" {
  description = "Security Group ID for the application"
  value       = aws_security_group.stack_priv_sg.id
}

output "aws_vpc" {
  description = "The ID of the created VPC"
  value       = aws_vpc.mystack_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.stack_subnet1_pub.id, aws_subnet.stack_subnet2_pub.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.stack_subnet_priv1_webapp.id, aws_subnet.stack_subnet_priv2_webapp.id, aws_subnet.stack_subnet_priv1_app_db.id, aws_subnet.stack_subnet_priv2_app_db.id]
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "efs_file_system_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.clixx_efs.id
}

output "load_balancer_dns" {
  description = "DNS of the Application Load Balancer"
  value       = aws_lb.stack_lb.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.clixx_asg.name
}


