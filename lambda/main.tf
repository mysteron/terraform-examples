data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

variable "lambda_function_name" {
  description = "This is a test lambda function (Bartek)"
  type        = string
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = "lambda_function.zip"

  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_file = "lambda/src/index.js"
  output_path = "lambda_function.zip"

}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}
