# CloudWatch Alarm 7 days before ACM certifcate Expires




resource "aws_cloudwatch_metric_alarm" "resume_tls_expire_in_week" {
  provider            = aws.region-virginia
  alarm_description   = "Resume TLS certificate expiring in 7 days"
  alarm_name          = "resume_tls_expire_in_week"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DaysToExpiry"
  namespace           = "AWS/CertificateManager"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = "7"
  treat_missing_data  = "ignore"
  alarm_actions       = [aws_sns_topic.cert_expiring.arn]
  dimensions = {
    CertificateArn = data.aws_acm_certificate.amazon_issued.arn
  }
}
