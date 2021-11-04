# Define users

variable external_developers_list {
  type = map

  default = {
     1 : { "name": "JohnCarter",
           "email": "johncarter7061@gmail.com"
          },
     2 : { "name": "VadimTest",
           "email": "vadim.lun9u@gmail.com"
          },
     3 : { "name": "ViktorTodorov",
           "email": "viktor.todorov@limechain.tech"
          },
     4 : { "name": "JohnCarter",
           "email": "johncarter7061@gmail.com"
          },
  }

}

# Create external developer group
resource "aws_iam_group" "external_developers" {
  name = "external-developers"
  path = "/users/"
}

# Access throuth AWS Programmatic access

resource "aws_iam_user" "external_developers" {
    for_each = var.external_developers_list
    name = each.value["name"]
    path = "/user/"

    tags = {
      Environment = "aws_account",
      Project     = "Universe",
      Email       = each.value["email"]
    }
}

locals  {
  users_list = [ for user in var.external_developers_list: user.name ]
}

output testuser {
  value = local.users_list
}

# Assigne users to group
resource "aws_iam_group_membership" "external_developers" {
  name = "external-developers"

#  users = local.users_list
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
        Resource = data.aws_eks_cluster.dev.arn
      },
    ]
  })
}
