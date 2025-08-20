#!/bin/bash
set -e

echo "📥 Importing Existing AWS Resources into Terraform"

# This script imports existing AWS resources into Terraform state
# Run this BEFORE applying terraform for the first time

ACCOUNT_ID="714876270401"
REGION="eu-north-1"

echo "Importing DynamoDB tables..."
terraform import module.dynamodb.aws_dynamodb_table.notifications Notifications
terraform import module.dynamodb.aws_dynamodb_table.user_notification_preferences UserNotificationPreferences
terraform import module.dynamodb.aws_dynamodb_table.user_devices UserDevices
terraform import module.dynamodb.aws_dynamodb_table.nordpool_prices NordPoolPrices
terraform import module.dynamodb.aws_dynamodb_table.nordpool_analytics NordPoolAnalytics
terraform import module.dynamodb.aws_dynamodb_table.conversations Conversations
terraform import module.dynamodb.aws_dynamodb_table.messages Messages
terraform import module.dynamodb.aws_dynamodb_table.user_sessions UserSessions
terraform import module.dynamodb.aws_dynamodb_table.user_activities UserActivities
terraform import module.dynamodb.aws_dynamodb_table.marketing_events MarketingEvents

echo "Importing SNS topics..."
terraform import module.sns.aws_sns_topic.general arn:aws:sns:${REGION}:${ACCOUNT_ID}:nordplug-general
terraform import module.sns.aws_sns_topic.notifications arn:aws:sns:${REGION}:${ACCOUNT_ID}:nordplug-notifications
terraform import module.sns.aws_sns_topic.peak_alerts arn:aws:sns:${REGION}:${ACCOUNT_ID}:nordplug-peak-alerts
terraform import module.sns.aws_sns_topic.maintenance arn:aws:sns:${REGION}:${ACCOUNT_ID}:nordplug-maintenance

echo "Importing Lambda functions..."
terraform import module.lambda.aws_lambda_function.nordplug_notifications nordplug-notifications
terraform import 'module.lambda.aws_lambda_function.python_lambdas["notifications"]' notifications
terraform import 'module.lambda.aws_lambda_function.python_lambdas["s3-dynamodb"]' s3-dynamodb
terraform import 'module.lambda.aws_lambda_function.python_lambdas["analytics-processor"]' analytics-processor
terraform import 'module.lambda.aws_lambda_function.python_lambdas["messaging-api"]' messaging-api
terraform import 'module.lambda.aws_lambda_function.python_lambdas["user-service"]' user-service
terraform import 'module.lambda.aws_lambda_function.python_lambdas["analytics-enhanced"]' analytics-enhanced
terraform import 'module.lambda.aws_lambda_function.python_lambdas["analytics-api"]' analytics-api
terraform import 'module.lambda.aws_lambda_function.python_lambdas["nordpool-api-s3"]' nordpool-api-s3
terraform import 'module.lambda.aws_lambda_function.python_lambdas["stream-processor"]' stream-processor
terraform import 'module.lambda.aws_lambda_function.python_lambdas["api-dynamodb"]' api-dynamodb

echo "Importing API Gateway..."
terraform import module.api_gateway.aws_api_gateway_rest_api.nordplug_api ef2he3q010

echo "Importing IAM roles..."
terraform import module.lambda.aws_iam_role.nordplug_notifications_role nordplug-notifications-lambda-role

echo ""
echo "🎉 Import complete! You can now run terraform plan to see any differences."
echo "Note: You may need to create placeholder zip files for Lambda functions."