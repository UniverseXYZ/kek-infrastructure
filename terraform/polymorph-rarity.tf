variable "dev_lambda_function_name" {
  default = "polymorph_rarity_dev"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "polymorph_rarity_dev" {
  filename      = "Polymorph-Rarity-Cloud-lambda-function.zip"
  function_name = "PolymorphRarityDev"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.go"
  source_code_hash = filebase64sha256("Polymorph-Rarity-Cloud-lambda-function.zip")

  runtime = "go1.x"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.polymorph_rarity_dev,
  ]
  vpc_config {
    subnet_ids = [data.aws_eks_cluster.dev.vpc_config[0].vpc_id]
    security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]
  }
  environment {
    variables = {
      DB_URL = aws_docdb_cluster.universe_dev.endpoint
      USERNAME = "kekdao"
      PASSWORD = var.DEV_DB_PASSWORD
      POLYMORPH_DB = "rarities"
      RARITY_COLLECTION = "polymorphs-rarity"
    }
  }
}

resource "aws_cloudwatch_log_group" "polymorph_rarity_dev" {
  name              = "/aws/lambda/${var.dev_lambda_function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}