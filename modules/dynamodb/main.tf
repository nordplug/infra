# DynamoDB Tables

# Notifications Table
resource "aws_dynamodb_table" "notifications" {
  name           = "Notifications"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"
  range_key      = "sk"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  ttl {
    attribute_name = "ttlEpoch"
    enabled        = true
  }

  tags = var.common_tags
}

# User Notification Preferences Table
resource "aws_dynamodb_table" "user_notification_preferences" {
  name         = "UserNotificationPreferences"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = var.common_tags
}

# User Devices Table
resource "aws_dynamodb_table" "user_devices" {
  name           = "UserDevices"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"
  range_key      = "deviceId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "deviceId"
    type = "S"
  }

  tags = var.common_tags
}

# NordPool Prices Table
resource "aws_dynamodb_table" "nordpool_prices" {
  name           = "NordPoolPrices"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "DeliveryDate"
  range_key      = "DeliveryStart"

  attribute {
    name = "DeliveryDate"
    type = "S"
  }

  attribute {
    name = "DeliveryStart"
    type = "S"
  }

  tags = var.common_tags
}

# NordPool Analytics Table
resource "aws_dynamodb_table" "nordpool_analytics" {
  name         = "NordPoolAnalytics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.common_tags
}

# Conversations Table (for messaging)
resource "aws_dynamodb_table" "conversations" {
  name         = "Conversations"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.common_tags
}

# Messages Table (for messaging)
resource "aws_dynamodb_table" "messages" {
  name           = "Messages"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "conversationId"
  range_key      = "timestamp"

  attribute {
    name = "conversationId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = var.common_tags
}

# User Sessions Table
resource "aws_dynamodb_table" "user_sessions" {
  name         = "UserSessions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = var.common_tags
}

# User Activities Table
resource "aws_dynamodb_table" "user_activities" {
  name           = "UserActivities"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"
  range_key      = "timestamp"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = var.common_tags
}

# Marketing Events Table
resource "aws_dynamodb_table" "marketing_events" {
  name         = "MarketingEvents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.common_tags
}

# Outputs
output "table_names" {
  value = {
    notifications                = aws_dynamodb_table.notifications.name
    user_notification_preferences = aws_dynamodb_table.user_notification_preferences.name
    user_devices                 = aws_dynamodb_table.user_devices.name
    nordpool_prices              = aws_dynamodb_table.nordpool_prices.name
    nordpool_analytics           = aws_dynamodb_table.nordpool_analytics.name
    conversations                = aws_dynamodb_table.conversations.name
    messages                     = aws_dynamodb_table.messages.name
    user_sessions                = aws_dynamodb_table.user_sessions.name
    user_activities              = aws_dynamodb_table.user_activities.name
    marketing_events             = aws_dynamodb_table.marketing_events.name
  }
}

output "table_arns" {
  value = {
    notifications                = aws_dynamodb_table.notifications.arn
    user_notification_preferences = aws_dynamodb_table.user_notification_preferences.arn
    user_devices                 = aws_dynamodb_table.user_devices.arn
    nordpool_prices              = aws_dynamodb_table.nordpool_prices.arn
    nordpool_analytics           = aws_dynamodb_table.nordpool_analytics.arn
    conversations                = aws_dynamodb_table.conversations.arn
    messages                     = aws_dynamodb_table.messages.arn
    user_sessions                = aws_dynamodb_table.user_sessions.arn
    user_activities              = aws_dynamodb_table.user_activities.arn
    marketing_events             = aws_dynamodb_table.marketing_events.arn
  }
}