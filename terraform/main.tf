terraform {
  cloud {
    organization = "UniverseXYZ"

    workspaces {
      name = "kek-infrastructure"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-kekdao"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "tfstate-kekdao"
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "tfstate-lock-kekdao"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tfstate-lock-kekdao"
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_route53_zone" "main" {
  name = "universe.xyz"

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "universe.xyz"
  type    = "MX"
  ttl     = "3600"

  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM",
  ]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "universe.xyz"
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:_spf.google.com include:amazonses.com -all",
    "google-site-verification=NIQ2z9406qIesc3T-s5GvB8FXlscpCCvH52zPhfmEVs"
  ]
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_dmarc.universe.xyz"
  type    = "TXT"
  ttl     = "3600"
  records = ["v=DMARC1;p=quarantine;pct=100;fo=1"]
}

resource "aws_route53_record" "gitbook" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "docs.universe.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = ["hosting.gitbook.io"]
}

resource "aws_route53_record" "signal" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "signal.universe.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = ["snapshotpage.b-cdn.net"]
}
