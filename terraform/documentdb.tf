#####ALPHA#####

resource "aws_docdb_cluster_instance" "universe_dev_cluster_master" {
  identifier         = "universe-dev-master"
  cluster_identifier = aws_docdb_cluster.universe_dev.id
  instance_class     = "db.r6g.xlarge"
  promotion_tier     = 0
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_dev_cluster_slave" {
  identifier         = "universe-dev-slave"
  cluster_identifier = aws_docdb_cluster.universe_dev.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_dev_cluster_slave2" {
  identifier         = "universe-dev-slave2"
  cluster_identifier = aws_docdb_cluster.universe_dev.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}


resource "aws_docdb_cluster" "universe_dev" {
  cluster_identifier              = "universe-dev"
  apply_immediately               = true
  engine                          = "docdb"
  engine_version                  = "4.0.0"
  master_username                 = "kekdao"
  master_password                 = var.DEV_DB_PASSWORD
  vpc_security_group_ids          = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]
  availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_cluster_parameter_group_name = "universe-dev-no-ssl"
  kms_key_id                      = "arn:aws:kms:us-east-1:076129510628:key/aa38a691-e008-49a8-8cc2-8241a962a7c9" #aws-managed
  storage_encrypted               = true
  port                            = "27017"
  skip_final_snapshot             = true
  tags = {
    BusinessUse  = "Universe Dev"
    CreationDate = "01/17/2022"
    Creator      = "trevor.latson"
  }
}

#####DEV#####

resource "aws_docdb_cluster_instance" "universe_rinkeby_cluster_slave" {
  identifier         = "universe-rinkeby-slave"
  cluster_identifier = aws_docdb_cluster.universe_rinkeby.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_rinkeby_cluster_slave2" {
  identifier         = "universe-rinkeby-slave2"
  cluster_identifier = aws_docdb_cluster.universe_rinkeby.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_rinkeby_cluster_master" {
  identifier         = "universe-rinkeby-master"
  cluster_identifier = aws_docdb_cluster.universe_rinkeby.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 0
  apply_immediately  = true
}

resource "aws_docdb_cluster" "universe_rinkeby" {
  cluster_identifier              = "universe-rinkeby"
  apply_immediately               = true
  engine                          = "docdb"
  engine_version                  = "4.0.0"
  master_username                 = "kekdao"
  master_password                 = var.DEV_DB_PASSWORD
  db_subnet_group_name            = "dev-universe-20210505160751512000000001"
  vpc_security_group_ids          = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]
  availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_cluster_parameter_group_name = "universe-dev-no-ssl"
  kms_key_id                      = "arn:aws:kms:us-east-1:076129510628:key/aa38a691-e008-49a8-8cc2-8241a962a7c9" #aws-managed
  storage_encrypted               = true
  port                            = "27017"
  skip_final_snapshot             = true
  tags = {
    BusinessUse  = "Universe Rinkeby"
    CreationDate = "02/16/2022"
    Creator      = "trevor.latson"
  }
}

#####PROD#####

resource "aws_docdb_cluster_instance" "universe_prod_cluster_slave_1" {
  identifier         = "universe-prod-slave1"
  cluster_identifier = aws_docdb_cluster.universe_prod.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_prod_cluster_slave_2" {
  identifier         = "universe-prod-slave2"
  cluster_identifier = aws_docdb_cluster.universe_prod.id
  instance_class     = "db.r6g.large"
  promotion_tier     = 1
  apply_immediately  = true
}

resource "aws_docdb_cluster_instance" "universe_prod_cluster_master" {
  identifier         = "universe-prod-master"
  cluster_identifier = aws_docdb_cluster.universe_prod.id
  instance_class     = "db.r6g.xlarge"
  promotion_tier     = 0
  apply_immediately  = true
}

resource "aws_docdb_cluster" "universe_prod" {
  cluster_identifier              = "universe-prod"
  snapshot_identifier             = "alpha-gold-03-20-3033"
  apply_immediately               = true
  engine                          = "docdb"
  engine_version                  = "4.0.0"
  master_username                 = "kekdao"
  master_password                 = var.PROD_DB_PASSWORD
  db_subnet_group_name            = "prod-universe-20210520134829492400000003"
  vpc_security_group_ids          = [data.aws_eks_cluster.prod.vpc_config[0].cluster_security_group_id]
  availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_cluster_parameter_group_name = "universe-dev-no-ssl"
  kms_key_id                      = "arn:aws:kms:us-east-1:076129510628:key/aa38a691-e008-49a8-8cc2-8241a962a7c9" #aws-managed
  storage_encrypted               = true
  port                            = "27017"
  skip_final_snapshot             = true
  tags = {
    BusinessUse  = "Universe Prod"
    CreationDate = "03/16/2022"
    Creator      = "trevor.latson"
  }
}