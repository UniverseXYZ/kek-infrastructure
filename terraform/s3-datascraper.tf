#####ALPHA#####

resource "aws_s3_bucket" "universe_dev_datascraper_video" {
  bucket = "universe-dev-datascraper-video-new"
  acl    = "private"

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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universe-dev-datascraper-video"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universe_dev_datascraper_video" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_dev_datascraper_video.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_dev_datascraper_video" {
  bucket = aws_s3_bucket.universe_dev_datascraper_video.id
  policy = data.aws_iam_policy_document.universe_dev_datascraper_video.json
}

resource "aws_s3_bucket" "universe_dev_datascraper_images" {
  bucket = "universe-dev-datascraper-images-new"
  acl    = "private"

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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universe-dev-datascraper-images"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universe_dev_datascraper_images" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_dev_datascraper_images.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_dev_datascraper_images" {
  bucket = aws_s3_bucket.universe_dev_datascraper_images.id
  policy = data.aws_iam_policy_document.universe_dev_datascraper_images.json
}

resource "aws_s3_bucket" "universe_dev_datascraper_audio" {
  bucket = "universe-dev-datascraper-audio-new"
  acl    = "private"

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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universe-dev-datascraper-audio"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universe_dev_datascraper_audio" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_dev_datascraper_audio.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_dev_datascraper_audio" {
  bucket = aws_s3_bucket.universe_dev_datascraper_audio.id
  policy = data.aws_iam_policy_document.universe_dev_datascraper_audio.json
}


resource "aws_s3_bucket" "universe_dev_datascraper_models" {
  bucket = "universe-dev-datascraper-models-new"
  acl    = "private"

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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universe-dev-datascraper-models"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universe_dev_datascraper_models" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_dev_datascraper_models.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_dev_datascraper_models" {
  bucket = aws_s3_bucket.universe_dev_datascraper_models.id
  policy = data.aws_iam_policy_document.universe_dev_datascraper_models.json
}

resource "aws_s3_bucket" "universe_dev_datascraper_misc" {
  bucket = "universe-dev-datascraper-misc-new"
  acl    = "private"

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
    allowed_origins = ["https://alpha.universe.xyz", "https://alpha-alphauniversexyz-origin.s3-website-us-east-1.amazonaws.com"]
    expose_headers  = []
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "universe-dev-datascraper-misc"
    Project     = "kekdao"
    Environment = "dev"
  }
}

data "aws_iam_policy_document" "universe_dev_datascraper_misc" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_dev_datascraper_misc.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_dev_datascraper_misc" {
  bucket = aws_s3_bucket.universe_dev_datascraper_misc.id
  policy = data.aws_iam_policy_document.universe_dev_datascraper_misc.json
}

resource "aws_iam_user" "dev_datascraper_iam_user" {
  name = "universe-dev-datascraper-iam-user"
  path = "/"

  tags = {
    Name        = "universe-dev-datascraper-iam-user"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_iam_access_key" "dev_datascraper_iam_user" {
  user = aws_iam_user.dev_datascraper_iam_user.name
}

resource "aws_iam_user_policy" "dev_datascraper_iam_user" {
  name = "dev_datascraper_iam_policy"
  user = aws_iam_user.dev_datascraper_iam_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::universe-dev-datascraper-*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:ListQueues",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:us-east-1:076129510628:datascraper-*"
    }
  ]
}
EOF
}

output "dev_datascraper_iam_api_key_id" {
  value = aws_iam_access_key.dev_datascraper_iam_user.id
}

output "dev_datascraper_iam_api_secret" {
  sensitive = true
  value     = aws_iam_access_key.dev_datascraper_iam_user.secret
}

#####DEV#####

resource "aws_s3_bucket" "universe_rinkeby_datascraper_sqs" {
  bucket = "universe-rinkeby-datascraper-sqs-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-sqs"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_sqs" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_sqs.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_sqs" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_sqs.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_sqs.json
}

resource "aws_s3_bucket" "universe_rinkeby_datascraper_video" {
  bucket = "universe-rinkeby-datascraper-video-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-video"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_video" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_video.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_video" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_video.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_video.json
}

resource "aws_s3_bucket" "universe_rinkeby_datascraper_images" {
  bucket = "universe-rinkeby-datascraper-images-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-images"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_images" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_images.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_images" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_images.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_images.json
}

resource "aws_s3_bucket" "universe_rinkeby_datascraper_audio" {
  bucket = "universe-rinkeby-datascraper-audio-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-audio"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_audio" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_audio.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_audio" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_audio.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_audio.json
}

resource "aws_s3_bucket" "universe_rinkeby_datascraper_models" {
  bucket = "universe-rinkeby-datascraper-models-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-models"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_models" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_models.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_models" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_models.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_models.json
}

resource "aws_s3_bucket" "universe_rinkeby_datascraper_misc" {
  bucket = "universe-rinkeby-datascraper-misc-new"
  acl    = "private"

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
    Name        = "universe-rinkeby-datascraper-misc"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

data "aws_iam_policy_document" "universe_rinkeby_datascraper_misc" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_rinkeby_datascraper_misc.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_rinkeby_datascraper_misc" {
  bucket = aws_s3_bucket.universe_rinkeby_datascraper_misc.id
  policy = data.aws_iam_policy_document.universe_rinkeby_datascraper_misc.json
}

resource "aws_iam_user" "rinkeby_datascraper_iam_user" {
  name = "universe-rinkeby-datascraper-iam-user"
  path = "/"

  tags = {
    Name        = "universe-rinkeby-datascraper-iam-user"
    Project     = "kekdao"
    Environment = "rinkeby"
  }
}

resource "aws_iam_access_key" "rinkeby_datascraper_iam_user" {
  user = aws_iam_user.rinkeby_datascraper_iam_user.name
}

resource "aws_iam_user_policy" "rinkeby_datascraper_iam_user" {
  name = "rinkeby_datascraper_iam_policy"
  user = aws_iam_user.rinkeby_datascraper_iam_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::universe-rinkeby-datascraper-*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:ListQueues",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:us-east-1:076129510628:rinkeby-datascraper-*"
    }
  ]
}
EOF
}

output "rinkeby_datascraper_iam_api_key_id" {
  value = aws_iam_access_key.rinkeby_datascraper_iam_user.id
}

output "rinkeby_datascraper_iam_api_secret" {
  sensitive = true
  value     = aws_iam_access_key.rinkeby_datascraper_iam_user.secret
}

#####PROD#####

resource "aws_s3_bucket" "universe_prod_datascraper_video" {
  bucket = "universe-prod-datascraper-video-new"
  acl    = "private"

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
    Name        = "universe-prod-datascraper-video"
    Project     = "kekdao"
    Environment = "prod"
  }
}

data "aws_iam_policy_document" "universe_prod_datascraper_video" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_prod_datascraper_video.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_prod_datascraper_video" {
  bucket = aws_s3_bucket.universe_prod_datascraper_video.id
  policy = data.aws_iam_policy_document.universe_prod_datascraper_video.json
}

resource "aws_s3_bucket" "universe_prod_datascraper_images" {
  bucket = "universe-prod-datascraper-images-new"
  acl    = "private"

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
    Name        = "universe-prod-datascraper-images"
    Project     = "kekdao"
    Environment = "prod"
  }
}

data "aws_iam_policy_document" "universe_prod_datascraper_images" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_prod_datascraper_images.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_prod_datascraper_images" {
  bucket = aws_s3_bucket.universe_prod_datascraper_images.id
  policy = data.aws_iam_policy_document.universe_prod_datascraper_images.json
}

resource "aws_s3_bucket" "universe_prod_datascraper_audio" {
  bucket = "universe-prod-datascraper-audio-new"
  acl    = "private"

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
    Name        = "universe-prod-datascraper-audio"
    Project     = "kekdao"
    Environment = "prod"
  }
}

data "aws_iam_policy_document" "universe_prod_datascraper_audio" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_prod_datascraper_audio.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_prod_datascraper_audio" {
  bucket = aws_s3_bucket.universe_prod_datascraper_audio.id
  policy = data.aws_iam_policy_document.universe_prod_datascraper_audio.json
}

resource "aws_s3_bucket" "universe_prod_datascraper_models" {
  bucket = "universe-prod-datascraper-models-new"
  acl    = "private"

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
    Name        = "universe-prod-datascraper-models"
    Project     = "kekdao"
    Environment = "prod"
  }
}

data "aws_iam_policy_document" "universe_prod_datascraper_models" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_prod_datascraper_models.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_prod_datascraper_models" {
  bucket = aws_s3_bucket.universe_prod_datascraper_models.id
  policy = data.aws_iam_policy_document.universe_prod_datascraper_models.json
}

resource "aws_s3_bucket" "universe_prod_datascraper_misc" {
  bucket = "universe-prod-datascraper-misc-new"
  acl    = "private"

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
    Name        = "universe-prod-datascraper-misc"
    Project     = "kekdao"
    Environment = "prod"
  }
}

data "aws_iam_policy_document" "universe_prod_datascraper_misc" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universe_prod_datascraper_misc.arn)
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "universe_prod_datascraper_misc" {
  bucket = aws_s3_bucket.universe_prod_datascraper_misc.id
  policy = data.aws_iam_policy_document.universe_prod_datascraper_misc.json
}

resource "aws_iam_user" "prod_datascraper_iam_user" {
  name = "universe-prod-datascraper-iam-user"
  path = "/"

  tags = {
    Name        = "universe-prod-datascraper-iam-user"
    Project     = "kekdao"
    Environment = "prod"
  }
}

resource "aws_iam_access_key" "prod_datascraper_iam_user" {
  user = aws_iam_user.prod_datascraper_iam_user.name
}

resource "aws_iam_user_policy" "prod_datascraper_iam_user" {
  name = "prod_datascraper_iam_policy"
  user = aws_iam_user.prod_datascraper_iam_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::universe-prod-datascraper-*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:ListQueues",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:us-east-1:076129510628:prod-datascraper-*"
    }
  ]
}
EOF
}

output "prod_datascraper_iam_api_key_id" {
  value = aws_iam_access_key.prod_datascraper_iam_user.id
}

output "prod_datascraper_iam_api_secret" {
  sensitive = true
  value     = aws_iam_access_key.prod_datascraper_iam_user.secret
}
