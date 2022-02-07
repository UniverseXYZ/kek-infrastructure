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

resource "aws_ecr_repository" "marketplace-backend" {
  name                 = "marketplace-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "marketplace-indexer" {
  name                 = "marketplace-indexer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-watchdog" {
  name                 = "universe-watchdog"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "polymorph-rarity" {
  name                 = "polymorph-rarity"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}