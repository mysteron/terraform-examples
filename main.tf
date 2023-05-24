provider "aws" {
  region = "eu-central-1"
}

module "example_ec2" {
  source        = "./ec2"
  instance_type = "t2.micro"
  asg_name      = "bartek-autoscaling-group"
  asg_min_size  = 1
  asg_max_size  = 3
}

module "example_lambda" {
  source               = "./lambda"
  lambda_function_name = "bartek-lambda-function"
}

module "example_api_gateway" {
  source               = "./api-gateway"
  lambda_invoke_arn    = module.example_lambda.lambda_function_arn
  lambda_function_name = module.example_lambda.lambda_function_name
}

module "example_vpc" {
  source = "./vpc"

}
output "ec2_outputs" {
  value = module.example_ec2
}

output "lambda_outputs" {
  value = module.example_lambda
}

output "api_gateway_outputs" {
  value = module.example_api_gateway
}
