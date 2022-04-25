variable "ATLAS_ORG_OWNER_PRIVATEKEY" {
  type = string
}

##### DEV #####

resource "aws_cloudformation_stack" "dev_atlas" {
  name                       = "universe-dev-atlas"
  template_url               = "https://aws-quickstart.s3.amazonaws.com/quickstart-mongodb-atlas/templates/mongodb-atlas-peering-existingvpc.template.yaml"
  parameters = {
    VPC                      = "vpc-0d321bfd608628cdd" # dev EKS cluster EC2 worker node VPC
    RouteTableCIDRBlock      = "10.107.0.0/16"
    PublicKey                = "zygdoxzk"
    PrivateKey               = var.ATLAS_ORG_OWNER_PRIVATEKEY # var resides in Terraform Cloud
    OrgId                    = "625d7b1a14c1a266e513ea4e"
    RegisterMongoDBResources = "Yes"
    ProjectName              = "Universe-Dev"
    ClusterName              = "Universe-Dev-Cluster1"
    ClusterRegion            = "us-east-1"
    ClusterInstanceSize      = "M10"
    QSS3BucketName           = "aws-quickstart"
    QSS3KeyPrefix            = "quickstart-mongodb-atlas/"
    QSS3BucketRegion         = "us-east-1"
  }
}