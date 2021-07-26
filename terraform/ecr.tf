resource "aws_ecr_repository" "universeapp-backend" {
  name                 = "universeapp-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "kekbackend" {
  name                 = "kekbackend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}
