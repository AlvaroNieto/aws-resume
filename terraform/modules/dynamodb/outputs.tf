output "table_name" {
  value = aws_dynamodb_table.visit_counter.name
}

output "table_arn" {
  value = aws_dynamodb_table.visit_counter.arn
}
