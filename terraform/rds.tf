# RDS Enhanced monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds-enhanced-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "dev_db" {
  description             = "RDS dev encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "dev-db"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_kms_key" "auctions_db" {
  description             = "RDS auctions encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "auctions-db"
    Project     = "kekdao"
    Environment = "auctions"
  }
}

resource "aws_kms_key" "alpha_db" {
  description             = "RDS alpha encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "alpha-db"
    Project     = "kekdao"
    Environment = "alpha"
  }
}

resource "aws_kms_key" "dev_nft_db" {
  description             = "RDS nft dev encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "dev-nft-db"
    Project     = "kekdao"
    Environment = "nft"
  }
}

resource "aws_kms_key" "prod_db" {
  description             = "RDS production encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "prod-db"
    Project     = "kekdao"
    Environment = "production"
  }
}

module "dev_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier        = "dev-universe"
  engine            = "postgres"
  engine_version    = "12.7"
  instance_class    = "db.t3.small"
  allocated_storage = 8
  storage_encrypted = true
  kms_key_id        = aws_kms_key.dev_db.arn

  name     = "kekdao"
  username = "kekdao"
  password = var.DEV_DB_PASSWORD
  port     = "5432"

  vpc_security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]

  maintenance_window = "Mon:03:00-Mon:03:30"
  backup_window      = "03:30-04:30"

  backup_retention_period = 0

  subnet_ids = data.aws_eks_cluster.dev.vpc_config[0].subnet_ids

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  family               = "postgres12"
  major_engine_version = "12"

  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  apply_immediately = false

  tags = {
    Project     = "kekdao"
    Environment = "dev"
  }
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

module "dev_nft_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier        = "dev-nft-universe"
  engine            = "postgres"
  engine_version    = "12.7"
  instance_class    = "db.m4.large"
  allocated_storage = 10
  storage_encrypted = true
  kms_key_id        = aws_kms_key.dev_nft_db.arn

  name     = "kekdao"
  username = "kekdao"
  password = var.DEV_NFT_DB_PASSWORD
  port     = "5432"

  vpc_security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]

  maintenance_window = "Mon:03:00-Mon:03:30"
  backup_window      = "03:30-04:30"

  backup_retention_period = 7

  subnet_ids = data.aws_eks_cluster.dev.vpc_config[0].subnet_ids

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  family               = "postgres12"
  major_engine_version = "12"

  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  apply_immediately = false

  tags = {
    Project     = "kekdao"
    Environment = "nft"
  }
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}


module "auctions_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier        = "auctions-universe"
  engine            = "postgres"
  engine_version    = "12.7"
  instance_class    = "db.m6g.large"
  allocated_storage = 80
  storage_encrypted = true
  kms_key_id        = aws_kms_key.alpha_db.arn

  name     = "kekdao"
  username = "kekdao"
  password = var.AUCTIONS_DB_PASSWORD
  port     = "5432"

  vpc_security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]

  maintenance_window = "Mon:03:00-Mon:03:30"
  backup_window      = "03:30-04:30"

  backup_retention_period = 7

  subnet_ids = data.aws_eks_cluster.dev.vpc_config[0].subnet_ids

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  family               = "postgres12"
  major_engine_version = "12"

  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  apply_immediately = false

  tags = {
    Project     = "kekdao"
    Environment = "auctions"
  }
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

module "alpha_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier        = "alpha-universe"
  engine            = "postgres"
  engine_version    = "12.7"
  instance_class    = "db.m6g.large"
  allocated_storage = 80
  storage_encrypted = true
  kms_key_id        = aws_kms_key.alpha_db.arn

  name     = "kekdao"
  username = "kekdao"
  password = var.ALPHA_DB_PASSWORD
  port     = "5432"

  vpc_security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]

  maintenance_window = "Mon:03:00-Mon:03:30"
  backup_window      = "03:30-04:30"

  backup_retention_period = 7

  subnet_ids = data.aws_eks_cluster.dev.vpc_config[0].subnet_ids

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  family               = "postgres12"
  major_engine_version = "12"

  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  apply_immediately = false

  tags = {
    Project     = "kekdao"
    Environment = "alpha"
  }
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

module "prod_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier        = "prod-universe"
  engine            = "postgres"
  engine_version    = "12.7"
  instance_class    = "db.m6g.large"
  allocated_storage = 80
  storage_encrypted = true
  kms_key_id        = aws_kms_key.prod_db.arn

  name     = "kekdao"
  username = "kekdao"
  password = var.PROD_DB_PASSWORD
  port     = "5432"

  vpc_security_group_ids = [data.aws_eks_cluster.prod.vpc_config[0].cluster_security_group_id]

  maintenance_window = "Mon:03:00-Mon:03:30"
  backup_window      = "03:30-04:30"

  backup_retention_period = 7

  subnet_ids = data.aws_eks_cluster.prod.vpc_config[0].subnet_ids

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  family               = "postgres12"
  major_engine_version = "12"

  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  apply_immediately = false

  tags = {
    Project     = "kekdao"
    Environment = "production"
  }
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

variable "PROD_DB_PASSWORD" {
  type = string
}

variable "ALPHA_DB_PASSWORD" {
  type = string
}

variable "AUCTIONS_DB_PASSWORD" {
  type = string
}

variable "DEV_DB_PASSWORD" {
  type = string
}

variable "DEV_NFT_DB_PASSWORD" {
  type = string
}
