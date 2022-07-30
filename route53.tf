# Create Alias record towards Cloudfron Distribution from Route53

data "aws_route53_zone" "hosted_zone" {
  provider = aws.region-master
  name     = "sebastianmarynicz.co.uk."
}


# ACM Certifctate for portal.it-ops-zava.co.uk

data "aws_acm_certificate" "amazon_issued" {
  provider    = aws.region-virginia
  domain      = "sebastianmarynicz.co.uk"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


# Allias for portal.it-ops-zava.co.uk


resource "aws_route53_record" "resume_url" {
  provider = aws.region-master
  zone_id  = data.aws_route53_zone.hosted_zone.zone_id
  name     = join(".", [var.websites-name, data.aws_route53_zone.hosted_zone.name])
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_resume_project.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_resume_project.hosted_zone_id
    evaluate_target_health = false
  }
}
