resource "aws_s3_bucket" "static_website" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}