# IAM Roles for Lambda functions
resource "aws_iam_role" "nordplug_notifications_role" {
  name = "nordplug-notifications-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "nordplug_notifications_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.nordplug_notifications_role.name
}

resource "aws_iam_role_policy" "nordplug_notifications_permissions" {
  name = "nordplug-notifications-permissions"
  role = aws_iam_role.nordplug_notifications_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          "arn:aws:sns:${var.aws_region}:${var.account_id}:nordplug-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/Notifications",
          "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/UserNotificationPreferences"
        ]
      }
    ]
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "nordplug_notifications_logs" {
  name              = "/aws/lambda/nordplug-notifications"
  retention_in_days = 3
  tags              = var.common_tags
}

# Lambda Function - Nordplug Notifications (Node.js)
resource "aws_lambda_function" "nordplug_notifications" {
  function_name = "nordplug-notifications"
  role         = aws_iam_role.nordplug_notifications_role.arn
  handler      = "notifications-handler.handler"
  runtime      = "nodejs18.x"
  timeout      = 30
  memory_size  = 256

  # This will need to be updated with actual deployment zip
  filename         = "nordplug-notifications.zip"
  source_code_hash = filebase64sha256("nordplug-notifications.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN                    = var.sns_topics["general"]
      AWS_REGION_ID                    = var.aws_region
      AWS_ACCOUNT_ID                   = var.account_id
      PLATFORM_APPLICATION_ARN_PROD   = "arn:aws:sns:${var.aws_region}:${var.account_id}:app/APNS/nordplug-ios-app"
      PLATFORM_APPLICATION_ARN_SANDBOX = "arn:aws:sns:${var.aws_region}:${var.account_id}:app/APNS_SANDBOX/nordplug-ios-app-sandbox"
      LOG_LEVEL                        = "INFO"
    }
  }

  depends_on = [aws_cloudwatch_log_group.nordplug_notifications_logs]
  tags       = var.common_tags
}

# Lambda Function URL
resource "aws_lambda_function_url" "nordplug_notifications_url" {
  function_name      = aws_lambda_function.nordplug_notifications.function_name
  authorization_type = "NONE"
  invoke_mode        = "BUFFERED"

  cors {
    allow_credentials = false
    allow_headers    = ["content-type", "authorization", "x-id-token"]
    allow_methods    = ["POST"]
    allow_origins    = ["*"]
    max_age         = 86400
  }
}

# Output the function URL
output "nordplug_notifications_url" {
  value = aws_lambda_function_url.nordplug_notifications_url.function_url
}

# Generic Lambda role for other functions
resource "aws_iam_role" "lambda_execution_role" {
  name = "nordplug-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy" "lambda_dynamodb_sns" {
  name = "lambda-dynamodb-sns-permissions"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:*"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:*"
        ]
        Resource = [
          "arn:aws:sns:${var.aws_region}:${var.account_id}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::nordplug-*/*"
        ]
      }
    ]
  })
}

# Python Lambda functions (generic configuration)
locals {
  python_lambdas = [
    "notifications",
    "s3-dynamodb", 
    "analytics-processor",
    "messaging-api",
    "user-service",
    "analytics-enhanced",
    "analytics-api",
    "nordpool-api-s3",
    "stream-processor",
    "api-dynamodb"
  ]
}

resource "aws_cloudwatch_log_group" "python_lambda_logs" {
  for_each = toset(local.python_lambdas)
  
  name              = "/aws/lambda/${each.value}"
  retention_in_days = 3
  tags              = var.common_tags
}

resource "aws_lambda_function" "python_lambdas" {
  for_each = toset(local.python_lambdas)

  function_name = each.value
  role         = aws_iam_role.lambda_execution_role.arn
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.9"
  timeout      = 30
  memory_size  = 256

  # Placeholder - will need actual deployment zips
  filename         = "${each.value}.zip"
  source_code_hash = filebase64sha256("${each.value}.zip")

  environment {
    variables = {
      AWS_REGION = var.aws_region
      AWS_ACCOUNT_ID = var.account_id
      # Add more environment variables as needed per function
    }
  }

  depends_on = [aws_cloudwatch_log_group.python_lambda_logs]
  tags       = var.common_tags
}

# Outputs
output "function_arns" {
  value = merge(
    {
      "nordplug-notifications" = aws_lambda_function.nordplug_notifications.arn
    },
    {
      for k, v in aws_lambda_function.python_lambdas : k => v.arn
    }
  )
}