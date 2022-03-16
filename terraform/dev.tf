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

module "dev_universe_xyz_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "universe.xyz"
  domain_name                 = "dev.universe.xyz"
  wait_for_certificate_issued = true
}

module "lambda_at_edge" {
  source  = "cloudposse/cloudfront-s3-cdn/aws//modules/lambda@edge"
  version = "0.82.3"
  functions = {
    viewer_request = {
      source = [{
        content  = <<-EOT
        exports.handler = async (event, context, callback) => {

            const request = event.Records[0].cf.request;
            const headers = request.headers;

            const user = 'graviton';
            const pass = 'IsAwesome2022';

            const basicAuthentication = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');

            if (typeof headers.authorization == 'undefined' || headers.authorization[0].value != basicAuthentication) {
                const body = 'You are not authorized to enter';
                const response = {
                    status: '401',
                    statusDescription: 'Unauthorized',
                    body: body,
                    headers: {
                        'www-authenticate': [{key: 'WWW-Authenticate', value:'Basic'}]
                    },
                };
                callback(null, response);
            }
            callback(null, request);
        };
        EOT
        filename = "index.js"
      }]
      runtime      = "nodejs12.x"
      handler      = "index.handler"
      event_type   = "viewer-request"
      include_body = false
    }
  }
}

module "dev_universe_xyz_frontend" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.82.3"
  name               = "dev.universe.xyz"
  encryption_enabled = true
  environment        = "dev"
  # DNS Settings
  parent_zone_id      = aws_route53_zone.main.zone_id
  acm_certificate_arn = module.dev_universe_xyz_acm_certificate.arn
  dns_alias_enabled   = true
  aliases             = ["dev.universe.xyz"]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled = true
  s3_website_password_enabled = true
  allow_ssl_requests_only = false
  cors_allowed_methods    = ["GET", "HEAD"]
  cors_allowed_origins    = ["dev.universe.xyz"]
  cors_allowed_headers    = ["*"]
  index_document  = "index.html" # absolute path in the S3 bucket
  error_document  = "index.html" # absolute path in the S3 bucket
  custom_error_response = [{
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }]
  logging_enabled = false

  lambda_function_association = module.lambda_at_edge.lambda_function_association
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
    "RU", # Russia
    "ZW", # Zimbabwe
  ]
  geo_restriction_type     = "blacklist"
  minimum_protocol_version = "TLSv1.2_2019"
  depends_on               = [module.dev_universe_xyz_acm_certificate]
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

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://dev.universe.xyz", "https://dev-devuniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
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
