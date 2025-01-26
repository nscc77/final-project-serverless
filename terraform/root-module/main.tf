module "s3-static-website" {
  source      = "../s3-module/"
  name_prefix = "sample-app-website"

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