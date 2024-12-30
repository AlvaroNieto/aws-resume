data "archive_file" "lambda" {
  type  = "zip"
  source_file = "../lambda_function.py"
  output_path = "../lambda_function.zip"
}


resource "aws_iam_role" "lambda_execution_role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = var.policy_name
  description = "Policy to allow Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ],
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}



resource "aws_lambda_function" "visit_counter_lambda" {
  function_name = var.lambda_name
  runtime       = var.runtime
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.handler
  description   = "Acccess a dynamodb and i++ a curvisits counter"

  filename         = "../lambda_function.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

}

