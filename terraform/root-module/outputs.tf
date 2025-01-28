output "frontend_bucket_name" {
  description = "The name of the S3 bucket for the frontend app"
  value       = module.static_website.bucket_name
}

output "frontend_bucket_region" {
  description = "The AWS region of the S3 bucket"
  value       = module.static_website.region
}

output "frontend_website_endpoint" {
  description = "The website endpoint of the S3 bucket"
  value       = module.static_website.website_endpoint
}