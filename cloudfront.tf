# CloudFront Distribution for Resume Project

data "aws_ssm_parameter" "aws_referer" {
  provider = aws.region-master
  name     = "/resume/cloudfront/referer"
}




resource "aws_cloudfront_distribution" "s3_distribution_resume_project" {
  provider = aws.region-master

  origin {
    domain_name = aws_s3_bucket.resume_bucket.website_endpoint
    origin_id   = "resume_project_origin"


    custom_header {
      name  = "Referer"
      value = data.aws_ssm_parameter.aws_referer.value
    }



    custom_origin_config {
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      http_port              = 80
      https_port             = 443
    }

  }


  aliases = ["www.sebastianmarynicz.co.uk"]

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"



  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "resume_project_origin"
    compress         = true

    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.CORS_S3Origin.id
    cache_policy_id            = data.aws_cloudfront_cache_policy.CachingOptimized.id
    viewer_protocol_policy     = "redirect-to-https"
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id

  }

  ordered_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "resume_project_origin"
    path_pattern     = "*"
    compress         = true

    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.CORS_S3Origin.id
    cache_policy_id            = data.aws_cloudfront_cache_policy.CachingOptimized.id
    viewer_protocol_policy     = "redirect-to-https"
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id


  }






  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.amazon_issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }
}


data "aws_cloudfront_origin_request_policy" "CORS_S3Origin" {
  provider = aws.region-master
  name     = "Managed-CORS-S3Origin"
}


data "aws_cloudfront_cache_policy" "CachingOptimized" {
  provider = aws.region-master
  name     = "Managed-CachingOptimized"
}


data "aws_cloudfront_response_headers_policy" "security_headers" {
  provider = aws.region-master
  name     = "Managed-SecurityHeadersPolicy"
}
