variable "aws_region" {
  default = "us-east-1"
}
variable "aws_account_id" {
  default = "076129510628"
}
variable "dev_lambda_function_name" {
  default = "polymorph_rarity_dev"
}
variable "stage_name" {
  default = "rarity-lambda-proxy"
  type    = string
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "lambda_functions/Polymorph-Rarity-Cloud-lambda-function"
  output_path = "Polymorph-Rarity-Cloud-lambda-function.zip"
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
  filename         = "Polymorph-Rarity-Cloud-lambda-function.zip"
  function_name    = "PolymorphRarityDev"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.go"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "go1.x"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_cloudwatch_log_group.polymorph_rarity_dev,
  ]
  vpc_config {
    subnet_ids         = ["subnet-008fc641ca146ab49"] #eksctl-dev-i-universe-xyz-cluster/SubnetPublicUSEAST1A
    security_group_ids = [data.aws_eks_cluster.dev.vpc_config[0].cluster_security_group_id]
  }
  environment {
    variables = {
      DB_URL            = aws_docdb_cluster.universe_dev.endpoint
      USERNAME          = "kekdao"
      PASSWORD          = var.DEV_DB_PASSWORD
      POLYMORPH_DB      = "polymorphs-rarity"
      RARITY_COLLECTION = "rarities"
    }
  }
}

resource "aws_cloudwatch_log_group" "polymorph_rarity_dev" {
  name              = "/aws/lambda/${var.dev_lambda_function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaVPCAccessExecutionRole
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
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
        "logs:PutLogEvents",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_api_gateway_rest_api" "polymorph_rarity_dev" {
  name = "polymorph_rarity_dev"
}

resource "aws_api_gateway_resource" "polymorph_rarity_dev" {
  parent_id   = aws_api_gateway_rest_api.polymorph_rarity_dev.root_resource_id
  path_part   = "rarity-lambda-proxy"
  rest_api_id = aws_api_gateway_rest_api.polymorph_rarity_dev.id
}

resource "aws_api_gateway_method" "polymorph_rarity_dev" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.polymorph_rarity_dev.id
  rest_api_id   = aws_api_gateway_rest_api.polymorph_rarity_dev.id
}

resource "aws_api_gateway_integration" "polymorph_rarity_dev" {
  http_method             = aws_api_gateway_method.polymorph_rarity_dev.http_method
  resource_id             = aws_api_gateway_resource.polymorph_rarity_dev.id
  rest_api_id             = aws_api_gateway_rest_api.polymorph_rarity_dev.id
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.polymorph_rarity_dev.invoke_arn
}

resource "aws_api_gateway_deployment" "polymorph_rarity_dev" {
  rest_api_id = aws_api_gateway_rest_api.polymorph_rarity_dev.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.polymorph_rarity_dev.id,
      aws_api_gateway_method.polymorph_rarity_dev.id,
      aws_api_gateway_integration.polymorph_rarity_dev.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "polymorph_rarity_dev" {
  deployment_id = aws_api_gateway_deployment.polymorph_rarity_dev.id
  rest_api_id   = aws_api_gateway_rest_api.polymorph_rarity_dev.id
  stage_name    = "rarity-lambda-proxy"
  depends_on    = [aws_cloudwatch_log_group.polymorph_rarity_dev_stage]
}

resource "aws_cloudwatch_log_group" "polymorph_rarity_dev_stage" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.polymorph_rarity_dev.id}/${var.stage_name}"
  retention_in_days = 14
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.polymorph_rarity_dev.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.polymorph_rarity_dev.id}/*/${aws_api_gateway_method.polymorph_rarity_dev.http_method}${aws_api_gateway_resource.polymorph_rarity_dev.path}"
}