# My own Email Domain 



resource "aws_ses_email_identity" "verify_my_email" {
  provider = aws.region-ire
  email    = data.aws_ssm_parameter.sns_endpoint.value
}



resource "aws_ses_receipt_rule_set" "forwarding" {
  provider      = aws.region-ire
  rule_set_name = "forwarding"
}


data "aws_lambda_function" "lambda_forwarder" {
  provider      = aws.region-ire
  function_name = "SesForwarder-dev-SesForwarder"
  qualifier     = "PROD"
}

resource "aws_ses_receipt_rule" "forwarding_rule" {
  provider      = aws.region-ire
  name          = "forwarding_rule"
  rule_set_name = aws_ses_receipt_rule_set.forwarding.id
  recipients    = [var.recipient_contact_SES_Forwarder, var.recipient_powershell_SES_Forwarder, var.recipient_admin_SES_Forwarder_ire]
  enabled       = true
  scan_enabled  = true


  s3_action {
    bucket_name       = aws_s3_bucket.SesForwarder.id
    position          = 1
    object_key_prefix = "mails"
  }

  lambda_action {
    function_arn    = data.aws_lambda_function.lambda_forwarder.qualified_arn
    invocation_type = "Event"
    position        = 2
  }

  depends_on = [
    aws_s3_bucket_policy.allow_SES_bucket_attachment,

  ]
}


resource "aws_ses_active_receipt_rule_set" "forwarding_rule_activate" {
  provider      = aws.region-ire
  rule_set_name = aws_ses_receipt_rule_set.forwarding.id
}


# SES Notifications for Bounce, Complaint and Delivery


data "aws_ses_domain_identity" "domain_identity" {
  provider = aws.region-ire
  domain   = "sebastianmarynicz.co.uk"
}



resource "aws_ses_identity_notification_topic" "bounce" {
  provider                 = aws.region-ire
  topic_arn                = aws_sns_topic.SES_bounce.arn
  notification_type        = "Bounce"
  identity                 = data.aws_ses_domain_identity.domain_identity.domain
  include_original_headers = true
}


resource "aws_ses_identity_notification_topic" "complaint" {
  provider                 = aws.region-ire
  topic_arn                = aws_sns_topic.SES_Complaint.arn
  notification_type        = "Complaint"
  identity                 = data.aws_ses_domain_identity.domain_identity.domain
  include_original_headers = true
}



