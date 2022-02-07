resource "aws_docdb_cluster_instance" "universe_dev_cluster_instance1" {
  identifier         = "universe-dev"
  cluster_identifier = aws_docdb_cluster.universe_dev.id
  instance_class     = "db.t4g.medium"
  promotion_tier     = 1
}

resource "aws_docdb_cluster_instance" "universe_dev_cluster_instance2" {
  identifier         = "universe-dev2"
  cluster_identifier = aws_docdb_cluster.universe_dev.id
  instance_class     = "db.t4g.medium"
  promotion_tier     = 1
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