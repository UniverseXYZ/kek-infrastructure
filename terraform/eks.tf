resource "aws_kms_key" "dev_eks" {
  description             = "EKS dev encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "dev-eks"
    Project     = "kekdao"
    Environment = "dev"
  }
}

resource "aws_kms_key" "prod_eks" {
  description             = "EKS prod encryption key"
  deletion_window_in_days = 14
  enable_key_rotation     = true

  tags = {
    Name        = "prod-eks"
    Project     = "kekdao"
    Environment = "production"
  }
}

data "aws_eks_cluster" "dev" {
  name = "dev-i-universe-xyz"
}

data "aws_eks_cluster" "prod" {
  name = "prod-i-universe-xyz"
}
