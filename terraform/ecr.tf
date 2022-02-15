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

resource "aws_ecr_repository" "universe-datascraper-block-consumer" {
  name                 = "universe-datascraper-block-consumer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-block-producer" {
  name                 = "universe-datascraper-block-producer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-metadata-consumer" {
  name                 = "universe-datascraper-metadata-consumer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-metadata-producer" {
  name                 = "universe-datascraper-metadata-producer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-transfer-consumer" {
  name                 = "universe-datascraper-transfer-consumer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-transfer-producer" {
  name                 = "universe-datascraper-transfer-producer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-mediafiles-consumer" {
  name                 = "universe-datascraper-mediafiles-consumer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-mediafiles-producer" {
  name                 = "universe-datascraper-mediafiles-producer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_ecr_repository" "universe-datascraper-api" {
  name                 = "universe-datascraper-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}
