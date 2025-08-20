# SNS Topics for notifications

# General notifications topic (used by admin panel)
resource "aws_sns_topic" "general" {
  name = "nordplug-general"
  tags = var.common_tags
}

# Price notifications topic (daily summaries)
resource "aws_sns_topic" "notifications" {
  name = "nordplug-notifications"
  tags = var.common_tags
}

# Price alerts topic (peak alerts)
resource "aws_sns_topic" "peak_alerts" {
  name = "nordplug-peak-alerts"
  tags = var.common_tags
}

# Maintenance notifications topic
resource "aws_sns_topic" "maintenance" {
  name = "nordplug-maintenance"
  tags = var.common_tags
}

# SNS Platform Applications for mobile push notifications
# Note: These require certificates/keys that should be managed separately
# For now, we'll reference the existing ones

# Production APNS Platform Application (requires certificate)
# This would typically be created with actual certificate data
# For now, we'll import the existing one or create a data source

# Sandbox APNS Platform Application (requires certificate)
# This would typically be created with actual certificate data
# For now, we'll import the existing one or create a data source

# CloudWatch Log Groups for SNS delivery status
resource "aws_cloudwatch_log_group" "sns_platform_application_logs" {
  for_each = toset([
    "sns/eu-north-1/${var.account_id}/app/APNS/nordplug-ios-app/Success",
    "sns/eu-north-1/${var.account_id}/app/APNS/nordplug-ios-app/Failure",
    "sns/eu-north-1/${var.account_id}/app/APNS_SANDBOX/nordplug-ios-app-sandbox/Success", 
    "sns/eu-north-1/${var.account_id}/app/APNS_SANDBOX/nordplug-ios-app-sandbox/Failure"
  ])
  
  name              = each.value
  retention_in_days = 3
  tags              = var.common_tags
}

# Outputs
output "topic_arns" {
  value = {
    general      = aws_sns_topic.general.arn
    notifications = aws_sns_topic.notifications.arn
    peak_alerts  = aws_sns_topic.peak_alerts.arn
    maintenance  = aws_sns_topic.maintenance.arn
  }
}

output "topic_names" {
  value = {
    general      = aws_sns_topic.general.name
    notifications = aws_sns_topic.notifications.name
    peak_alerts  = aws_sns_topic.peak_alerts.name
    maintenance  = aws_sns_topic.maintenance.name
  }
}