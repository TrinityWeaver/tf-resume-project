# SNS topic for alarm notification


resource "aws_sns_topic" "cert_expiring" {
  provider          = aws.region-virginia
  name              = "Resume-TLS-Cert-Expiring"
  display_name      = "Resume TLS Certificate Expiring"
  kms_master_key_id = "alias/aws/sns"
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


# SNS for SES Bounce and Complaint


resource "aws_sns_topic" "SES_bounce" {
  provider          = aws.region-ire
  name              = "SES-Bounce"
  display_name      = "SES-Bounce"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "subscription_bounce" {
  provider  = aws.region-ire
  topic_arn = aws_sns_topic.SES_bounce.arn
  protocol  = "email"
  endpoint  = var.recipient_admin_SES_Forwarder_ire
}


resource "aws_sns_topic" "SES_Complaint" {
  provider          = aws.region-ire
  name              = "SES-Complaint"
  display_name      = "SES-Complaint"
  kms_master_key_id = "alias/aws/sns"

}

resource "aws_sns_topic_subscription" "subscription_complaint" {
  provider               = aws.region-ire
  topic_arn              = aws_sns_topic.SES_Complaint.arn
  protocol               = "email"
  endpoint               = var.recipient_admin_SES_Forwarder_ire
  endpoint_auto_confirms = true
}

resource "aws_sns_topic" "SES_Delivery" {
  provider          = aws.region-ire
  name              = "SES-Delivery"
  display_name      = "SES-Delivery"
  kms_master_key_id = "alias/aws/sns"

}





