variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "main_key" {
  type        = string
  description = "The hash key of the DynamoDB table"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the DynamoDB table"
  default     = {}
}
