# Dev Marketplace Frontend

module "marketplace_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.15.1"
  zone_name                   = "universe.xyz"
  domain_name                 = "marketplace.dev.universe.xyz"
  wait_for_certificate_issued = true
}

module "marketplace_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.79.0"
  name               = "marketplace.dev.universe.xyz"
  encryption_enabled = true
  environment        = "marketplace"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.marketplace_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["marketplace.dev.universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled         = true
  allow_ssl_requests_only = false
  index_document          = "index.html" # absolute path in the S3 bucket
  error_document          = "index.html" # absolute path in the S3 bucket
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
    lambda_arn   = module.marketplace_frontend_basic_auth.arn
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.marketplace_universe_xyz_acm_certificate]
}


resource "aws_s3_bucket" "marketplace_lambda" {
  bucket = "universe-xyz-marketplace-lambda-functions"
  acl    = "private"

  versioning {
    enabled = true
  }
}

module "marketplace_frontend_basic_auth" {
  source                 = "transcend-io/lambda-at-edge/aws"
  version                = "0.4.0"
  name                   = "marketplace_frontend_basic_auth"
  description            = "Add basic-auth for marketplace frontend"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "lambda_functions/basic-auth"
  s3_artifact_bucket     = aws_s3_bucket.marketplace_lambda.id

  tags = {
    Environment = "marketplace"
  }
}

resource "aws_s3_bucket" "universeapp_assets_marketplace" {
  bucket = "universeapp-assets-marketplace"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["marketplace.dev.universe.xyz"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-marketplace"
    Project     = "kekdao"
    Environment = "marketplace"
  }
}
resource "aws_s3_bucket_policy" "universeapp_assets_marketplace" {
  bucket = aws_s3_bucket.universeapp_assets_marketplace.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsmarketplace"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_marketplace.arn,
          "${aws_s3_bucket.universeapp_assets_marketplace.arn}/*",
        ]
        #        Condition = {
        #          IpAddress = {
        #            "aws:SourceIp" = "0.0.0.0/0"
        #          }
        #        }
      },
    ]
  })
}

data "aws_iam_policy_document" "universeapp_assets_marketplace" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_marketplace.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_marketplace.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_marketplace" {
  name = "universeapp-assets-marketplace"
  path = "/app/"

  tags = {
    Environment = "marketplace"
  }
}

resource "aws_iam_access_key" "universeapp_assets_marketplace" {
  user = aws_iam_user.universeapp_assets_marketplace.name
}

resource "aws_iam_user_policy" "universeapp_assets_marketplace" {
  name   = "universeapp-assets-marketplace"
  user   = aws_iam_user.universeapp_assets_marketplace.name
  policy = data.aws_iam_policy_document.universeapp_assets_marketplace.json
}

output "universeapp_assets_marketplace_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_marketplace.id
}

output "universeapp_assets_marketplace_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_marketplace.secret
}


# Alpha Marketplace Frontend

module "alpha_marketplace_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.15.1"
  zone_name                   = "universe.xyz"
  domain_name                 = "marketplace.alpha.universe.xyz"
  wait_for_certificate_issued = true
}

module "alpha_marketplace_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.79.0"
  name               = "marketplace.alpha.universe.xyz"
  encryption_enabled = true
  environment        = "marketplace"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.alpha_marketplace_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["marketplace.alpha.universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled         = true
  allow_ssl_requests_only = false
  index_document          = "index.html" # absolute path in the S3 bucket
  error_document          = "index.html" # absolute path in the S3 bucket
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
    lambda_arn   = module.marketplace_frontend_basic_auth.arn #uses same as dev env
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.alpha_marketplace_universe_xyz_acm_certificate]
}

module "alpha_marketplace_frontend_basic_auth" {
  source                 = "transcend-io/lambda-at-edge/aws"
  version                = "0.4.0"
  name                   = "alpha_marketplace_frontend_basic_auth"
  description            = "Add basic-auth for marketplace frontend"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "lambda_functions/basic-auth"
  s3_artifact_bucket     = aws_s3_bucket.marketplace_lambda.id

  tags = {
    Environment = "marketplace"
  }
}

resource "aws_s3_bucket" "universeapp_assets_alpha_marketplace" {
  bucket = "universeapp-assets-alpha-marketplace"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["marketplace.alpha.universe.xyz"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-alpha-marketplace"
    Project     = "kekdao"
    Environment = "marketplace"
  }
}
resource "aws_s3_bucket_policy" "universeapp_assets_alpha_marketplace" {
  bucket = aws_s3_bucket.universeapp_assets_alpha_marketplace.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsAlphaMarketplace"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_alpha_marketplace.arn,
          "${aws_s3_bucket.universeapp_assets_alpha_marketplace.arn}/*",
        ]
      },
    ]
  })
}

data "aws_iam_policy_document" "universeapp_assets_alpha_marketplace" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_alpha_marketplace.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_alpha_marketplace.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_alpha_marketplace" {
  name = "universeapp-assets-alpha-marketplace"
  path = "/app/"

  tags = {
    Environment = "marketplace"
  }
}

resource "aws_iam_access_key" "universeapp_assets_alpha_marketplace" {
  user = aws_iam_user.universeapp_assets_alpha_marketplace.name
}

resource "aws_iam_user_policy" "universeapp_assets_alpha_marketplace" {
  name   = "universeapp-assets-alpha-marketplace"
  user   = aws_iam_user.universeapp_assets_alpha_marketplace.name
  policy = data.aws_iam_policy_document.universeapp_assets_alpha_marketplace.json
}

output "universeapp_assets_alpha_marketplace_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_alpha_marketplace.id
}

output "universeapp_assets_alpha_marketplace_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_alpha_marketplace.secret
}

# Prod Marketplace Frontend

module "prod_marketplace_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.15.1"
  zone_name                   = "universe.xyz"
  domain_name                 = "marketplace.universe.xyz"
  wait_for_certificate_issued = true
}

module "prod_marketplace_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.79.0"
  name               = "marketplace.universe.xyz"
  encryption_enabled = true
  environment        = "marketplace"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.prod_marketplace_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["marketplace.universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled         = true
  allow_ssl_requests_only = false
  index_document          = "index.html" # absolute path in the S3 bucket
  error_document          = "index.html" # absolute path in the S3 bucket
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
    lambda_arn   = module.marketplace_frontend_basic_auth.arn #uses same as dev env, to be removed when we go live
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.prod_marketplace_universe_xyz_acm_certificate]
}

resource "aws_s3_bucket" "universeapp_assets_prod_marketplace" {
  bucket = "universeapp-assets-prod-marketplace"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["marketplace.universe.xyz"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-prod-marketplace"
    Project     = "kekdao"
    Environment = "marketplace"
  }
}
resource "aws_s3_bucket_policy" "universeapp_assets_prod_marketplace" {
  bucket = aws_s3_bucket.universeapp_assets_prod_marketplace.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PRODBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsprodMarketplace"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_prod_marketplace.arn,
          "${aws_s3_bucket.universeapp_assets_prod_marketplace.arn}/*",
        ]
      },
    ]
  })
}

data "aws_iam_policy_document" "universeapp_assets_prod_marketplace" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_prod_marketplace.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_prod_marketplace.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_prod_marketplace" {
  name = "universeapp-assets-prod-marketplace"
  path = "/app/"

  tags = {
    Environment = "marketplace"
  }
}

resource "aws_iam_access_key" "universeapp_assets_prod_marketplace" {
  user = aws_iam_user.universeapp_assets_prod_marketplace.name
}

resource "aws_iam_user_policy" "universeapp_assets_prod_marketplace" {
  name   = "universeapp-assets-prod-marketplace"
  user   = aws_iam_user.universeapp_assets_prod_marketplace.name
  policy = data.aws_iam_policy_document.universeapp_assets_prod_marketplace.json
}

output "universeapp_assets_prod_marketplace_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_prod_marketplace.id
}

output "universeapp_assets_prod_marketplace_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_prod_marketplace.secret
}
