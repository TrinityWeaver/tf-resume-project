# SNS topic for alarm notification


resource "aws_sns_topic" "cert_expiring" {
  provider     = aws.region-virginia
  name         = "Resume-TLS-Cert-Expiring"
  display_name = "Resume TLS Certificate Expiring"
}


data "aws_ssm_parameter" "sns_endpoint" {
  provider = aws.region-master
  name     = "/resume/sns/endpoint"
}


resource "aws_sns_topic_subscription" "subscription" {
  provider               = aws.region-virginia
  topic_arn              = aws_sns_topic.cert_expiring.arn
  protocol               = "email"
  endpoint               = data.aws_ssm_parameter.sns_endpoint.value
  endpoint_auto_confirms = true
}
