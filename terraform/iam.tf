# Define users

variable "external_developers_list" {
  type = map(any)

  default = {
    1 : { "name" : "BorisBonin",
      "email" : "boris.bonin@limechain.tech"
    },
    2 : { "name" : "trevor_test",
      "email" : "trevor@universe.xyz"
    },
    3 : { "name" : "viktortodorov_test",
      "email" : "viktor.todorov@limechain.tech"
    },
    4 : { "name" : "PaulDonskikh",
      "email" : "donskikhinvest@gmail.com"
    },
    5 : { "name" : "felixshu",
      "email" : "felix@plugdefi.io"
    },
    6 : { "name" : "kunwang",
      "email" : "kun@plugdefi.io"
    },
    7 : { "name" : "george",
      "email" : "george@limechain.tech"
    },
    8 : { "name" : "sterios",
      "email" : "sterios.taskudis@limechain.tech"
    },
  }

}

# Create external developer group
resource "aws_iam_group" "external_developers" {
  name       = "external-developers"
  path       = "/users/"
  depends_on = [aws_iam_user.external_developers]
}

# Access throuth AWS Programmatic access

resource "aws_iam_user" "external_developers" {
  for_each = var.external_developers_list
  name     = each.value["name"]

  tags = {
    Environment = "aws_account",
    Project     = "Universe",
    Email       = each.value["email"]
  }
}

resource "aws_iam_access_key" "external_developers" {
  for_each   = var.external_developers_list
  user       = each.value["name"]
  depends_on = [aws_iam_user.external_developers]
}


# Assigne users to group
resource "aws_iam_group_membership" "external_developers" {
  name = "external-developers"

  users      = [for user in var.external_developers_list : user.name]
  group      = aws_iam_group.external_developers.name
  depends_on = [aws_iam_user.external_developers]
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
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
        ]
        Effect = "Allow"
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
        Effect = "Allow"
        Resource = [
          "arn:aws:iam::*:mfa/$${aws:username}",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" : "true"
          }
        }
      }
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
        Effect = "Allow"
        Resource = [
          data.aws_eks_cluster.dev.arn,
          #data.aws_eks_cluster.prod.arn
        ]
      },
    ]
  })
}


output "externale_developers_access_keys" {
  sensitive = true
  //value = aws_iam_access_key.external_developers["1"]
  value = [for i, u in var.external_developers_list : { name : aws_iam_access_key.external_developers[i].user, id : aws_iam_access_key.external_developers[i].id, key : aws_iam_access_key.external_developers[i].secret }]
}
