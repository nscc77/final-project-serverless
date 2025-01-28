resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "static_website_versioning" {
  bucket = aws_s3_bucket.static_website.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${var.AWS_ACCT_ID}:distribution/${aws_cloudfront_distribution.static_website.id}"
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name              = "${var.bucket_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior  = "always"
  signing_protocol  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_website" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = "S3-${var.bucket_name}"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}