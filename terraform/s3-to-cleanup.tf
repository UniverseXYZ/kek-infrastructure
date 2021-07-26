resource "aws_s3_bucket" "universeapp_local_dev" {
  bucket = "universeapp-local-dev"
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
    Name        = "universeapp-local-dev"
    Project     = "kekdao"
    Environment = "dev"
  }
}

