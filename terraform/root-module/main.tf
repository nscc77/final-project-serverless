module "dynamodb_table" {
  source        = "../dynamodb-module"
  table_name    = "serverless24b-redhat-dev-memo-app"
  billing_mode  = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key      = "PK"
  range_key     = "SK"

  attributes = [
    { name = "PK", type = "S" },
    { name = "SK", type = "S" }
  ]

  tags = {
    Environment = "Dev"
  }
}

module "lamda-module" {
  source = "../lamda-module"

  lambda_name        = "serverless24b-redhat-lambda"
  image_uri          = "021891586336.dkr.ecr.us-east-1.amazonaws.com/backend-app:86457a5885b3278ff9a60d5beaeb6aff301bf0c5"
  region             = "${var.AWS_REGION}"
  account_id         = "${var.AWS_ACCT_ID}"
  dynamodb_table_arn = module.dynamodb_table.table_arn

  paths = {
    "memo"   = "memo"
    "delete" = "delete"
    "public" = "public"
    "stats"  = "stats"
  }

  methods = {
    "memo"   = "GET"
    "delete" = "POST"
    "public" = "GET"
    "stats"  = "GET"
  }

  integration_methods = {
    "memo"   = "POST"
    "delete" = "POST"
  }

  api_resources = [
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/GET/memo",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/OPTIONS/memo",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/POST/memo",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/OPTIONS/memo/delete",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/POST/memo/delete",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/GET/public/stats",
    "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCT_ID}:${module.lamda-module.lamda_id}/dev/OPTIONS/public/stats"
  ]

  allowed_referers = [
    "https://www.spectrex.click/*",

  ]

  environment_variables = {
    TABLE_NAME     = module.dynamodb_table.table_name
    
  }

  tags = {
    Environment = "dev"
  }
}

module "ecr_repository" {
  source = "../ecr-module"

  repository_name      = "serverless24b-redhat-dev-backend"
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true

  lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images with tag 'dev' older than 15 days",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["dev"],
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 15
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT

  tags = {
    Environment = "dev"
  }
}

module "static_website" {
  source = "../s3-module"

  bucket_name       = "serverless24b-redhat-dev-${var.AWS_ACCT_ID}"
  force_destroy     = true
  enable_versioning = true
  index_document    = "index.html"
  error_document    = ""
  AWS_ACCT_ID = var.AWS_ACCT_ID

  tags = {
    Environment = "dev"
  }
}