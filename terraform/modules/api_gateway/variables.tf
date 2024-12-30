variable "api_name" {
  type        = string
  description = "The name of the API Gateway"
}

variable "path_part" {
  type        = string
  description = "The path part of the resource"
}

variable "lambda_arn" {
  type        = string
  description = "The ARN of the Lambda function to integrate"
}

variable "stage_name" {
  type        = string
  description = "The name of the deployment stage"
}

variable "region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "eu-south-2"  # You can change this to your desired region, or leave it as is.
}