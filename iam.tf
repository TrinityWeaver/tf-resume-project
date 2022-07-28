# IAM User Full S3 Access for GitHub Actions



resource "aws_iam_user" "s3_github_actions" {
  provider      = aws.region-master
  name          = "github-actions-s3-access"
  force_destroy = true
}

resource "aws_iam_access_key" "github_actions_access_key" {
  provider = aws.region-master
  user     = aws_iam_user.s3_github_actions.name
}


data "aws_iam_policy" "AmazonS3FullAccess" {
  provider = aws.region-master
  name     = "AmazonS3FullAccess"
}


resource "aws_iam_user_policy_attachment" "test-attach" {
  provider   = aws.region-master
  user       = aws_iam_user.s3_github_actions.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}
