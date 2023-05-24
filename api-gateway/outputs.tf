output "base_url" {
  description = "Base URL for API Gateway stage."
  value       = aws_apigatewayv2_stage.dev.invoke_url
}

output "api_gateway_endpoint" {
  description = "The endpoint of the API Gateway"
  value       = aws_apigatewayv2_api.lambda.api_endpoint
}
