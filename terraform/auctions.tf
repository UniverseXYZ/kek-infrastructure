# Frontend

module "auctions_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "${aws_route53_zone.main.name}"
  domain_name                 = "auctions.dev.universe.xyz"
  wait_for_certificate_issued = true
  depends_on                  = [ aws_route53_zone.main ]
}

module "auctions_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.40.0"
  name               = "auctions.dev.universe.xyz"
  encryption_enabled = true
  environment        = "auctions"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.auctions_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["auctions.dev.universe.xyz"]
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
    lambda_arn   = module.auctions_frontend_basic_auth.arn
  }]
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.auctions_universe_xyz_acm_certificate]
}


resource "aws_s3_bucket" "auctions_lambda" {
  bucket = "universe-xyz-auctions-lambda-functions"
  acl    = "private"

  versioning {
    enabled = true
  }
}

module "auctions_frontend_basic_auth" {
  source                 = "transcend-io/lambda-at-edge/aws"
  version                = "0.2.3"
  name                   = "auctions_frontend_basic_auth"
  description            = "Add basic-auth for auctions frontend"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "lambda_functions/basic-auth"
  s3_artifact_bucket     = aws_s3_bucket.auctions_lambda.id

  tags = {
    Environment = "auctions"
  }
}

resource "aws_s3_bucket" "universeapp_assets_auctions" {
  bucket = "universeapp-assets-auctions"
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
    allowed_origins = ["https://auctions.dev.universe.xyz", "https://auctions-auctionsdevuniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universeapp-assets-auctions"
    Project     = "kekdao"
    Environment = "auctions"
  }
}
resource "aws_s3_bucket_policy" "universeapp_assets_auctions" {
  bucket = aws_s3_bucket.universeapp_assets_auctions.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "universeappAssetsAuctions"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = [
          aws_s3_bucket.universeapp_assets_auctions.arn,
          "${aws_s3_bucket.universeapp_assets_auctions.arn}/*",
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

data "aws_iam_policy_document" "universeapp_assets_auctions" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_auctions.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_auctions.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_auctions" {
  name = "universeapp-assets-auctions"
  path = "/app/"

  tags = {
    Environment = "auctions"
  }
}

resource "aws_iam_access_key" "universeapp_assets_auctions" {
  user = aws_iam_user.universeapp_assets_auctions.name
}

resource "aws_iam_user_policy" "universeapp_assets_auctions" {
  name   = "universeapp-assets-auctions"
  user   = aws_iam_user.universeapp_assets_auctions.name
  policy = data.aws_iam_policy_document.universeapp_assets_auctions.json
}

output "universeapp_assets_auctions_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_auctions.id
}

output "universeapp_assets_auctions_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_auctions.secret
}
