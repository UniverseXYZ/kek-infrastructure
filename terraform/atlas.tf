# Reference: https://github.com/nikhil-mongo/aws-atlas-terraform
# To generate Atlas API Key Whitelist: https://github.com/mongodb-developer/get-started-aws-cfn/blob/main/aws-access-lister.sh

provider "mongodbatlas" {
  public_key = var.ATLAS_ORG_OWNER_PUBLICKEY
  private_key = var.ATLAS_ORG_OWNER_PRIVATEKEY
}

variable "ATLAS_ORG_OWNER_PRIVATEKEY" {
  type = string # var resides in Terraform Cloud as a sensitive value
}
variable "ATLAS_ORG_OWNER_PUBLICKEY" {
  type = string
  default = "zygdoxzk"
}
variable "atlas_region" {
  default     = "US_EAST_1"
  description = "Atlas Region"
}
variable "atlas_aws_region" {
  default     = "us-east-1"
  description = "AWS Region"
}
variable "atlas_dbuser" {
  default     = "kekdao"
  description = "The db user for Atlas"
}
variable "atlasorgid" {
  description = "Atlas Org ID"
  default     = "625d7b1a14c1a266e513ea4e"
}
variable "atlas_vpc_cidr" {
  description = "Atlas CIDR"
  default     = "192.168.232.0/21"
}

##### DEV #####

resource "mongodbatlas_project" "aws_atlas_dev" {
  name   = "Universe-Dev"
  org_id = var.atlasorgid
}

resource "mongodbatlas_cluster" "dev-cluster-atlas" {
  project_id   = mongodbatlas_project.aws_atlas_dev.id
  name         = "universe-dev-cluster-atlas"
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "US_EAST_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  cloud_backup                 = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.4"

  //Provider Settings "block"
  provider_name               = "AWS"
  disk_size_gb                = 100
  provider_instance_size_name = "M10"
}

resource "mongodbatlas_database_user" "db-user-dev" {
  username           = var.atlas_dbuser
  password           = var.DEV_DB_PASSWORD # var resides in Terraform Cloud as a sensitive value
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.aws_atlas_dev.id
  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }
  depends_on = [mongodbatlas_project.aws_atlas_dev]
}
resource "mongodbatlas_network_container" "dev_atlas_container" {
  atlas_cidr_block = var.atlas_vpc_cidr
  project_id       = mongodbatlas_project.aws_atlas_dev.id
  provider_name    = "AWS"
  region_name      = var.atlas_region
}

data "mongodbatlas_network_container" "dev_atlas_container" {
  container_id = mongodbatlas_network_container.dev_atlas_container.container_id
  project_id   = mongodbatlas_project.aws_atlas_dev.id
}

data "aws_caller_identity" "current" {}

resource "mongodbatlas_network_peering" "dev-aws-atlas" {
  accepter_region_name   = var.atlas_aws_region
  project_id             = mongodbatlas_project.aws_atlas_dev.id
  container_id           = mongodbatlas_network_container.dev_atlas_container.container_id
  provider_name          = "AWS"
  route_table_cidr_block = "10.107.0.0/16" # Dev VPC CIDR Range
  vpc_id                 = "vpc-0d321bfd608628cdd" # eksctl-dev-i-universe-xyz-cluster/VPC
  aws_account_id         = data.aws_caller_identity.current.account_id
}

resource "mongodbatlas_project_ip_access_list" "dev_vpc" {
  project_id = mongodbatlas_project.aws_atlas_dev.id
  cidr_block = "10.107.0.0/16" # Dev VPC CIDR Range
  comment    = "cidr block for AWS VPC"
}

resource "aws_route" "dev_peeraccess" {
  route_table_id            = "rtb-0be93ac828475034b" # Main Route Table for vpc-0d321bfd608628cdd
  destination_cidr_block    = var.atlas_vpc_cidr
  vpc_peering_connection_id = mongodbatlas_network_peering.dev-aws-atlas.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.dev_peer]
}

resource "aws_vpc_peering_connection_accepter" "dev_peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.dev-aws-atlas.connection_id
  auto_accept               = true
}

# Add rule in EKS security group to access Atlas outbound
resource "aws_security_group_rule" "dev_eks_to_atlas" {
  type              = "ingress"
  from_port         = 27015
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = [mongodbatlas_network_peering.dev-aws-atlas.route_table_cidr_block]
  security_group_id = "sg-08a7f35e5f8e06a5a" # eks-cluster-sg-dev-i-universe-xyz-1311676845
}