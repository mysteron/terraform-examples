output "asg_name" {

  description = "Auto scalling group name"
  value       = aws_autoscaling_group.asg.name
}

output "asg_id" {
  description = "Auto scalling group ID"
  value       = aws_autoscaling_group.asg.id
}

