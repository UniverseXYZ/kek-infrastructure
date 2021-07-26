# Frontend

module "dev_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "universe.xyz"
  domain_name                 = "dev.dao.universe.xyz"
  wait_for_certificate_issued = true
}

module "dev_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "dev.dao.universe.xyz"
  encryption_enabled = true
  environment        = "dev"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.dev_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["dev.dao.universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled = true
  index_document  = "index.html" # absolute path in the S3 bucket
  error_document  = "index.html" # absolute path in the S3 bucket
  custom_error_response = [{
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }]
  logging_enabled = false

  lambda_function_association = [{
    event_type   = "viewer-request"
    include_body = false
    lambda_arn   = module.dev_frontend_basic_auth.arn
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.dev_acm_certificate]
}

resource "aws_s3_bucket" "lambda" {
  bucket = "universe-xyz-lambda-functions"
  acl    = "private"

  versioning {
    enabled = true
  }
}

module "dev_frontend_basic_auth" {
  source                 = "transcend-io/lambda-at-edge/aws"
  version                = "0.2.3"
  name                   = "dev_frontend_basic_auth"
  description            = "Add basic-auth for dev frontend"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "lambda_functions/basic-auth"
  s3_artifact_bucket     = aws_s3_bucket.lambda.id

  tags = {
    Environment = "dev"
  }
}

# Frontend

module "universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "universe.xyz"
  domain_name                 = "universe.xyz"
  subject_alternative_names   = ["www.universe.xyz"]
  wait_for_certificate_issued = true
}

module "universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "universe.xyz"
  encryption_enabled = true
  environment        = "prod"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled = true
  index_document  = "index.html" # absolute path in the S3 bucket
  error_document  = "index.html" # absolute path in the S3 bucket
  custom_error_response = [{
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }]
  logging_enabled          = false
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.universe_xyz_acm_certificate]
}

resource "aws_s3_bucket" "universeapp_assets_dev" {
  bucket = "universeapp-assets-dev"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-dev"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universeapp_assets_dev" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_dev.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_dev.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_dev" {
  name = "universeapp-assets-dev"
  path = "/app/"

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_access_key" "universeapp_assets_dev" {
  user = aws_iam_user.universeapp_assets_dev.name
}

resource "aws_iam_user_policy" "universeapp_assets_dev" {
  name   = "universeapp-assets-dev"
  user   = aws_iam_user.universeapp_assets_dev.name
  policy = data.aws_iam_policy_document.universeapp_assets_dev.json
}

output "universeapp_assets_dev_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_dev.id
}

output "universeapp_assets_dev_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_dev.secret
}
