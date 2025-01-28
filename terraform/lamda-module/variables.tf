variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "URI of the ECR image to be used for the Lambda function"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}

variable "paths" {
  description = "Map of paths for the API Gateway"
  type        = map(string)
}

variable "methods" {
  description = "Map of paths to HTTP methods"
  type        = map(string)
  default     = {}
}

variable "integration_methods" {
  description = "Map of integration methods for Lambda"
  type        = map(string)
  default     = {}
}

variable "api_resources" {
  description = "List of ARNs for API Gateway resource policies"
  type        = list(string)
}

variable "allowed_referers" {
  description = "List of allowed referers for API Gateway"
  type        = list(string)
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to assign to AWS resources"
  type        = map(string)
  default     = {}
}
