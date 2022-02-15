resource "aws_s3_bucket" "universe_dev_datascraper_video" {
  bucket = "universe-dev-datascraper-video"
  acl    = "private"

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
    Name        = "universe-dev-datascraper-video"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "universe_dev_datascraper_images" {
  bucket = "universe-dev-datascraper-images"
  acl    = "private"

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
    Name        = "universe-dev-datascraper-images"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "universe_dev_datascraper_audio" {
  bucket = "universe-dev-datascraper-audio"
  acl    = "private"

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
    Name        = "universe-dev-datascraper-audio"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "universe_dev_datascraper_models" {
  bucket = "universe-dev-datascraper-models"
  acl    = "private"

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
    Name        = "universe-dev-datascraper-models"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "universe_dev_datascraper_misc" {
  bucket = "universe-dev-datascraper-misc"
  acl    = "private"

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
    Name        = "universe-dev-datascraper-misc"
    Project     = "kekdao"
    Environment = "dev"
  }
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
  value = aws_iam_access_key.dev_datascraper_iam_user.secret
}
