# AWS WAF Web Managed ACL


resource "aws_wafv2_web_acl" "resume_web_acl" {
  provider    = aws.region-virginia
  name        = "resume_web_acl"
  description = "Resume Project WEB ACL of a managed rules."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1


    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"


      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "resume_AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }

  }


  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2


    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"


      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "resume_AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4


    override_action {
      none {}
    }


    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"


      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "resume_AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 3


    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "CategorySocialMedia"
        }        

        excluded_rule {
          name = "CategorySeo"
        }        

        excluded_rule {
          name = "CategorySearchEngine"
        }        

        excluded_rule {
          name = "CategoryAdvertising"
        }        


      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "resume_AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }



  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "resume_waf_all_metric"
    sampled_requests_enabled   = true
  }
}
