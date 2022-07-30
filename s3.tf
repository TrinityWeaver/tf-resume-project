

# S3 Static Website Resume Project


resource "aws_s3_bucket" "resume_bucket" {
  provider      = aws.region-master
  bucket        = "sebastian-resume-bucket"
  force_destroy = true
}





resource "aws_s3_bucket_versioning" "resume_bucket_versioning" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "resume_project_static" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "resume_project_encryption" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_ownership_controls" "disable_acls" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}



data "aws_iam_policy_document" "resource_policy_to_allow_only_from_cf" {
  provider = aws.region-master
  statement {
    sid = "Allow get requests originating from cloudfront"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "${aws_s3_bucket.resume_bucket.arn}/*",
    ]
    condition {
      test     = "StringLike"
      values   = [data.aws_ssm_parameter.aws_referer.value]
      variable = "aws:Referer"
    }
  }

}


resource "aws_s3_bucket_policy" "allow_access_from_cf" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.id
  policy   = data.aws_iam_policy_document.resource_policy_to_allow_only_from_cf.json
}
