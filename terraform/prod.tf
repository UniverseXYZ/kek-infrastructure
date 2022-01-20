# Frontend

module "prod_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "universe.xyz"
  domain_name                 = "dao.universe.xyz"
  wait_for_certificate_issued = true
}

module "prod_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "dao.universe.xyz"
  encryption_enabled = true
  environment        = "prod"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.prod_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["dao.universe.xyz"]
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
  depends_on               = [module.prod_acm_certificate]
}

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

# s3 bucket with poliy controll

resource "aws_s3_bucket" "universeapp_assets_prod" {
  bucket = "universeapp-assets-prod"
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
    allowed_origins = ["https://universe.xyz", "https://prod-universexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-prod"
    Project     = "kek"
    Environment = "prod"
  }
}


resource "aws_s3_bucket_policy" "universeapp_assets_prod" {
  bucket = aws_s3_bucket.universeapp_assets_prod.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsProd"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_prod.arn,
          "${aws_s3_bucket.universeapp_assets_prod.arn}/*",
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

data "aws_iam_policy_document" "universeapp_assets_prod" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_prod.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_prod.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_prod" {
  name = "universeapp-assets-prod"
  path = "/app/"

  tags = {
    Environment = "prod"
  }
}

resource "aws_iam_access_key" "universeapp_assets_prod" {
  user = aws_iam_user.universeapp_assets_prod.name
}

resource "aws_iam_user_policy" "universeapp_assets_prod" {
  name   = "universeapp-assets-prod"
  user   = aws_iam_user.universeapp_assets_prod.name
  policy = data.aws_iam_policy_document.universeapp_assets_prod.json
}

output "universeapp_assets_prod_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_prod.id
}

output "universeapp_assets_prod_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_prod.secret
}
