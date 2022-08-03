output "s3_website_domain" {
  value       = aws_s3_bucket_website_configuration.resume_project_static.website_endpoint
  description = "S3 website domain"
}


output "resume_url" {
  value       = aws_route53_record.resume_url_www.fqdn
  description = "Resume Project URL"
}


