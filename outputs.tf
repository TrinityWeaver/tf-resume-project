output "s3_website_domain" {
  value       = aws_s3_bucket_website_configuration.resume_project_static.website_endpoint
  description = "S3 website domain"
}

