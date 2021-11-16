# Define users

variable external_developers_list {
  type = map

  default = {
     1 : { "name": "BorisBonin",
           "email": "boris.bonin@limechain.tech"
          },
     2 : { "name": "VadimTest",
           "email": "vadim.lun9u@gmail.com"
          },
     3 : { "name": "MehmetGurevin",
           "email": "mehmet.gurevin@octabase.com"
          },
  }

}

# Create external developer group
resource "aws_iam_group" "external_developers" {
  name = "external-developers"
  path = "/users/"
  depends_on = [aws_iam_user.external_developers]
}

# Access throuth AWS Programmatic access

resource "aws_iam_user" "external_developers" {
    for_each = var.external_developers_list
    name = each.value["name"]

    tags = {
      Environment = "aws_account",
      Project     = "Universe",
      Email       = each.value["email"]
    }
}

resource "aws_iam_access_key" "external_developers" {
    for_each = var.external_developers_list
    user = each.value["name"]
    depends_on = [aws_iam_user.external_developers]
}


# Assigne users to group
resource "aws_iam_group_membership" "external_developers" {
  name = "external-developers"

  users = [ for user in var.external_developers_list: user.name ]
  group = aws_iam_group.external_developers.name
}


resource "aws_iam_group_policy" "external_developer_policy_mfa" {
  name  = "external-developer-policy-mfa"
  group = aws_iam_group.external_developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowListActions"
        Action = [
          "iam:ListUsers",
          "iam:ListVirtualMFADevices",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowIndividualUserToListOnlyTheirOwnMFA"
        Action = [
          "iam:ListMFADevices",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:iam::*:mfa/*",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
      },
      {
        Sid = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
        Action = [
          "iam:DeactivateMFADevice",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:iam::*:mfa/$${aws:username}",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      },
      {
        Sid = "BlockMostAccessUnlessSignedInWithMFA"
        NotAction = [
          "iam:ChangePassword",
          "iam:CreateLoginProfile",
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ListUsers",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice"
        ]
        Effect   = "Deny"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent": "false"
          }
        }
      },
    ]
  })
}



resource "aws_iam_group_policy" "external_developer_policy_desribe_eks" {
  name  = "external-developer-policy-describe-eks"
  group = aws_iam_group.external_developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ExternalDeveloperPolicyDescribeEks"
        Action = [
          "eks:DescribeCluster"
        ]
        Effect   = "Allow"
        Resource = [
          data.aws_eks_cluster.dev.arn,
          data.aws_eks_cluster.prod.arn
        ]
      },
    ]
  })
}


output "externale_developers_access_keys" {
  sensitive = false
  //value = aws_iam_access_key.external_developers["1"]
  value = [ for i, u  in var.external_developers_list:  { name : aws_iam_access_key.external_developers[i].user , id: aws_iam_access_key.external_developers[i].id, key: aws_iam_access_key.external_developers[i].secret } ]
}
