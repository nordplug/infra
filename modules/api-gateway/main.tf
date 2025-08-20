# API Gateway REST API
resource "aws_api_gateway_rest_api" "nordplug_api" {
  name        = "NordplugAPI"
  description = "Nordplug API Gateway for mobile and web applications"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = var.common_tags
}

# API Gateway Resources (simplified structure - full structure would be very complex)
# This creates the basic structure, specific resources and methods would need to be added

# Root resource (/) already exists by default

# /users resource
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id
  parent_id   = aws_api_gateway_rest_api.nordplug_api.root_resource_id
  path_part   = "users"
}

# /conversations resource  
resource "aws_api_gateway_resource" "conversations" {
  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id
  parent_id   = aws_api_gateway_rest_api.nordplug_api.root_resource_id
  path_part   = "conversations"
}

# /marketdata resource
resource "aws_api_gateway_resource" "marketdata" {
  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id
  parent_id   = aws_api_gateway_rest_api.nordplug_api.root_resource_id
  path_part   = "marketdata"
}

# /analytics resource
resource "aws_api_gateway_resource" "analytics" {
  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id
  parent_id   = aws_api_gateway_rest_api.nordplug_api.root_resource_id
  path_part   = "analytics"
}

# Example method (GET /users - would need more specific implementation)
resource "aws_api_gateway_method" "users_get" {
  rest_api_id   = aws_api_gateway_rest_api.nordplug_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE"
}

# Example integration (would need to point to actual Lambda function)
resource "aws_api_gateway_integration" "users_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.users_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.account_id}:function:user-service/invocations"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "nordplug_api_deployment" {
  depends_on = [
    aws_api_gateway_method.users_get,
    aws_api_gateway_integration.users_get_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.nordplug_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_method.users_get.id,
      aws_api_gateway_integration.users_get_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stages
resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.nordplug_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.nordplug_api.id
  stage_name    = "dev"

  tags = var.common_tags
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.nordplug_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.nordplug_api.id
  stage_name    = "prod"

  tags = var.common_tags
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.nordplug_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.nordplug_api.id
  stage_name    = "v1"

  tags = var.common_tags
}

# Lambda permissions for API Gateway to invoke functions
resource "aws_lambda_permission" "api_gateway_lambda" {
  for_each = var.lambda_functions

  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.key
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.nordplug_api.execution_arn}/*/*"
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.nordplug_api.id}/prod"
  retention_in_days = 3
  tags              = var.common_tags
}

# Outputs
output "api_gateway_id" {
  value = aws_api_gateway_rest_api.nordplug_api.id
}

output "api_gateway_root_resource_id" {
  value = aws_api_gateway_rest_api.nordplug_api.root_resource_id
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.nordplug_api.execution_arn
}

output "api_gateway_invoke_url" {
  value = {
    dev  = "https://${aws_api_gateway_rest_api.nordplug_api.id}.execute-api.${var.aws_region}.amazonaws.com/dev"
    prod = "https://${aws_api_gateway_rest_api.nordplug_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
    v1   = "https://${aws_api_gateway_rest_api.nordplug_api.id}.execute-api.${var.aws_region}.amazonaws.com/v1"
  }
}