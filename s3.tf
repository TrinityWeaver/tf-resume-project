

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




data "aws_iam_policy_document" "resource_policy_to_allow_only_from_cf_and_push_from_git" {
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

  statement {
    sid = "Allow github user to push to the bucket"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.s3_github_actions.arn]
    }
    effect = "Allow"
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.resume_bucket.arn}/*",
    ]
  }

}


resource "aws_s3_bucket_policy" "allow_access_from_cf" {
  provider = aws.region-master
  bucket   = aws_s3_bucket.resume_bucket.id
  policy   = data.aws_iam_policy_document.resource_policy_to_allow_only_from_cf_and_push_from_git.json
}




# S3 for SesForwarder Lambda Function


resource "aws_s3_bucket" "SesForwarder" {
  provider      = aws.region-ire
  bucket        = "sebastian-ses-forwarder-lambda-ire"
  force_destroy = true
}


resource "aws_s3_bucket_acl" "SesForwarder_private" {
  provider = aws.region-ire
  bucket   = aws_s3_bucket.SesForwarder.id
  acl      = "private"
}



resource "aws_s3_bucket_server_side_encryption_configuration" "SesForwarder_encryption" {
  provider = aws.region-ire
  bucket   = aws_s3_bucket.SesForwarder.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "SesForwarder_disable_acls" {
  provider = aws.region-ire
  bucket   = aws_s3_bucket.SesForwarder.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}



data "aws_ssm_parameter" "aws_account_id" {
  provider = aws.region-master
  name     = "/resume/aws/account"
}




data "aws_iam_policy_document" "allow_ses_bucket_policy" {
  provider = aws.region-ire
  statement {
    sid = "Allow PutObject requests from SES"
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.SesForwarder.arn}/*",
    ]
    condition {
      test     = "StringLike"
      values   = [data.aws_ssm_parameter.aws_account_id.value]
      variable = "aws:Referer"
    }
  }

}


resource "aws_s3_bucket_policy" "allow_SES_bucket_attachment" {
  provider = aws.region-ire
  bucket   = aws_s3_bucket.SesForwarder.id
  policy   = data.aws_iam_policy_document.allow_ses_bucket_policy.json
}



resource "aws_s3_bucket_lifecycle_configuration" "bucket_delete_old_mails" {
  provider = aws.region-ire
  bucket   = aws_s3_bucket.SesForwarder.bucket

  rule {
    id = "mails"

    filter {
      prefix = "mails/"
    }

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 90
    }


    status = "Enabled"
  }
}
