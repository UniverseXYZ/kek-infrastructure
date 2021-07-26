resource "aws_s3_bucket" "universeapp_assets_local" {
  bucket = "universeapp-assets-local"
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
    Name        = "universeapp-assets-local"
    Project     = "kekdao"
    Environment = "local"
  }
}

data "aws_iam_policy_document" "universeapp_assets_local" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.universeapp_assets_local.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      format("%s/*", aws_s3_bucket.universeapp_assets_local.arn)
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user" "universeapp_assets_local" {
  name = "universeapp-assets-local"
  path = "/app/"

  tags = {
    Environment = "local"
  }
}

resource "aws_iam_access_key" "universeapp_assets_local" {
  user = aws_iam_user.universeapp_assets_local.name
}

resource "aws_iam_user_policy" "universeapp_assets_local" {
  name   = "universeapp-assets-local"
  user   = aws_iam_user.universeapp_assets_local.name
  policy = data.aws_iam_policy_document.universeapp_assets_local.json
}

output "universeapp_assets_local_access_key_id" {
  value = aws_iam_access_key.universeapp_assets_local.id
}

output "universeapp_assets_local_secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.universeapp_assets_local.secret
}
