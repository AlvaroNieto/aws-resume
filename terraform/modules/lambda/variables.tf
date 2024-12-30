variable "lambda_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "runtime" {
  type        = string
  description = "The runtime environment for the Lambda function"
  default     = "python3.13"
}

variable "handler" {
  type        = string
  description = "The handler for the Lambda function"
}

variable "filename" {
  type        = string
  description = "Path to the Lambda deployment package"
}

variable "role_name" {
  type        = string
  description = "The name of the IAM role for Lambda"
}

variable "policy_name" {
  type        = string
  description = "The name of the DynamoDB access policy"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "The ARN of the DynamoDB table"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}
