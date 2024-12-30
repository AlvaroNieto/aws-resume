resource "aws_dynamodb_table" "visit_counter" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.main_key

  attribute {
    name = var.main_key
    type = "S"
  }

  tags = var.tags
}