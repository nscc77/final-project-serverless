output "api_endpoint" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "lambda_id" {
  description = "The ID of the Lambda function"
  value       = aws_lambda_function.lambda.id
}

output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}