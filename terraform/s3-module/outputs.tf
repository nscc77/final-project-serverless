output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.static_website.id
}

output "website_endpoint" {
  description = "The website endpoint for the S3 bucket"
  value       = aws_s3_bucket.static_website.website_endpoint
}
