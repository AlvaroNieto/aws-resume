resource "aws_api_gateway_rest_api" "visit_counter_api" {
  name = var.api_name
  description = "API for visit counter"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.visit_counter_api.id
  parent_id   = aws_api_gateway_rest_api.visit_counter_api.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "any_method" {
  rest_api_id   = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.visit_counter_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.any_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

## OPTIONS method for CORS
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
    {
      "statusCode": 200
    }
    EOF
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.visit_counter_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST,PUT,DELETE'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

   depends_on = [aws_api_gateway_method_response.options_response]
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.visit_counter_api.id

    depends_on = [
      aws_api_gateway_method.any_method,             # Ensure methods exist
      aws_api_gateway_integration.lambda_integration, # Ensure integration exists
      aws_api_gateway_method.options_method,         # Ensure CORS OPTIONS method exists
      aws_api_gateway_integration.options_integration # Ensure OPTIONS integration exists
  ]

  lifecycle {
    create_before_destroy = true  # Ensure a new deployment is created before destroying the old one
  }
}

# API Gateway Stage (explicitly defined)
resource "aws_api_gateway_stage" "api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.visit_counter_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  stage_name    = var.stage_name
}
