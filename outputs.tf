

output "resume_url" {
  value       = aws_route53_record.resume_url_www.fqdn
  description = "Resume Project URL"
}


