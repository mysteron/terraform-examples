variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The ID of the AMI"
  type        = string
  default     = "ami-03aefa83246f44ef2"
}

variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix     = "my-launch-config-"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.bartek_test_security_group.id]
}

resource "aws_security_group" "bartek_test_security_group" {
  name        = "bartek_test_security_group"
  description = "Bartek Security Group"

  # Define your security group rules here
  # ...
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.asg_name
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_min_size
  launch_configuration = aws_launch_configuration.launch_config.name
  availability_zones   = ["eu-central-1b"]
}
