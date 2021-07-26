# Frontend

module "alpha_acm_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.10.0"
  zone_name                   = "universe.xyz"
  domain_name                 = "alpha.dao.universe.xyz"
  wait_for_certificate_issued = true
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
