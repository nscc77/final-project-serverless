output "frontend_bucket_name" {
  description = "The name of the S3 bucket for the frontend app"
  value       = module.static_website.bucket_name
}
