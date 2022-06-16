# Frontend

module "alpha_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "${aws_route53_zone.main.name}"
  domain_name                 = "alpha.dao.universe.xyz"
  wait_for_certificate_issued = true
  depends_on                  = [ aws_route53_zone.main ]
}

module "alpha_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "dao.universe.xyz"
  encryption_enabled = true
  environment        = "alpha"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.alpha_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["alpha.dao.universe.xyz"]
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
  logging_enabled = true

  lambda_function_association = [{
    event_type   = "viewer-request"
    include_body = false
    lambda_arn   = module.alpha_frontend_basic_auth.arn
  }]

  geo_restriction_locations = [
    "BY", # Belarus
    "CU", # Cuba
    "IR", # Iran
    "IQ", # Iraq
    "CI", # Côte d'Ivoire
    "LR", # Liberia
    "KP", # North Korea
    "SD", # Sudan
    "SY", # Syria
    "ZW", # Zimbabwe
  ]
  geo_restriction_type     = "blacklist"
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.alpha_acm_certificate]
}

module "alpha_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "${aws_route53_zone.main.name}"
  domain_name                 = "alpha.universe.xyz"
  wait_for_certificate_issued = true
  depends_on                  = [ aws_route53_zone.main ]
}

module "alpha_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "alpha.universe.xyz"
  encryption_enabled = true
  environment        = "alpha"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.alpha_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["alpha.universe.xyz"]
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
    lambda_arn   = module.alpha_frontend_basic_auth.arn
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.alpha_universe_xyz_acm_certificate]
}


resource "aws_s3_bucket" "alpha_lambda" {
  bucket = "universe-xyz-alpha-lambda-functions-new"
  acl    = "private"

  versioning {
    enabled = true
  }
}

module "alpha_frontend_basic_auth" {
  source                 = "transcend-io/lambda-at-edge/aws"
  version                = "0.2.3"
  name                   = "alpha_frontend_basic_auth"
  description            = "Add basic-auth for dev frontend"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "lambda_functions/basic-auth"
  s3_artifact_bucket     = aws_s3_bucket.alpha_lambda.id

  tags = {
    Environment = "alpha"
  }
}

resource "aws_s3_bucket" "universeapp_assets_alpha" {
  bucket = "universeapp-assets-alpha-new"
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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com", "https://alpha.xeenon.xyz", "https://alpha.hadron.xyz"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-alpha"
    Project     = "kekdao"
    Environment = "alpha"
  }
}
resource "aws_s3_bucket_policy" "universeapp_assets_alpha" {
  bucket = aws_s3_bucket.universeapp_assets_alpha.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsAlpha"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_alpha.arn,
          "${aws_s3_bucket.universeapp_assets_alpha.arn}/*",
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

data "aws_iam_policy_document" "universeapp_assets_alpha" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_alpha.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_alpha.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_alpha" {
  name = "universeapp-assets-alpha"
  path = "/app/"

  tags = {
    Environment = "alpha"
  }
}

resource "aws_iam_access_key" "universeapp_assets_alpha" {
  user = aws_iam_user.universeapp_assets_alpha.name
}

resource "aws_iam_user_policy" "universeapp_assets_alpha" {
  name   = "universeapp-assets-alpha"
  user   = aws_iam_user.universeapp_assets_alpha.name
  policy = data.aws_iam_policy_document.universeapp_assets_alpha.json
}

output "universeapp_assets_alpha_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_alpha.id
}

output "universeapp_assets_alpha_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_alpha.secret
}
