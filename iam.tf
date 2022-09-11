# IAM User Full S3 Access for GitHub Actions



resource "aws_iam_user" "s3_github_actions" {
  provider      = aws.region-master
  name          = "github-actions-s3-access"
  force_destroy = true
}



data "aws_iam_policy" "AmazonS3FullAccess" {
  provider = aws.region-master
  name     = "AmazonS3FullAccess"
}


resource "aws_iam_policy" "allow_git_invalidate_cache" {
  provider    = aws.region-master
  name        = "CustomAllowGitInvalidateCache"
  path        = "/"
  description = "Policy to allow to git user to invalidate cache"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Effect   = "Allow"
        Resource = [aws_cloudfront_distribution.s3_distribution_resume_project.arn]
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "cache_inv_attach" {
  provider   = aws.region-master
  user       = aws_iam_user.s3_github_actions.name
  policy_arn = aws_iam_policy.allow_git_invalidate_cache.arn
}



resource "aws_iam_user_policy_attachment" "test-attach" {
  provider   = aws.region-master
  user       = aws_iam_user.s3_github_actions.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}



data "aws_iam_role" "SES_Lambda_Forwarder_Role" {
  provider = aws.region-master
  name     = var.lambda_role_SES_Forwarder
}



resource "aws_iam_policy" "ses_lambda_forwarder_policy" {
  provider    = aws.region-ire
  name        = "CustomSESLambdaForwarderPolicy"
  path        = "/"
  description = "CustomSESLambdaForwarderPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"

        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.SesForwarder.arn}/*"
      },
      {
        Action = [
          "ses:SendRawEmail"

        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_SES" {
  provider   = aws.region-ire
  role       = data.aws_iam_role.SES_Lambda_Forwarder_Role.name
  policy_arn = aws_iam_policy.ses_lambda_forwarder_policy.arn
}


#data "aws_lambda_alias" "forwarder_PROD" {
#  provider      = aws.region-ire
#  function_name = var.lambda_role_SES_Forwarder
#  name          = "PROD"
#}
#

resource "aws_lambda_permission" "allow_SES_resource_policy" {
  provider       = aws.region-ire
  statement_id   = "Allows_SES_resource"
  action         = "lambda:InvokeFunction"
  function_name  = data.aws_lambda_function.lambda_forwarder.function_name
  qualifier      = "PROD"
  principal      = "ses.amazonaws.com"
  source_account = data.aws_ssm_parameter.aws_account_id.value
  source_arn     = aws_ses_receipt_rule.forwarding_rule.arn
}
