module "s3-static-website" {
  source      = "../s3-module/"
  name_prefix = "sample-app-website"

  providers = {
    aws.main         = aws.main
    aws.acm_provider = aws.acm_provider
  }

  website_domain_name = "sample-app.com"

  create_acm_certificate = true

  create_route53_hosted_zone = true


  website_server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  log_bucket_force_destroy = false
}