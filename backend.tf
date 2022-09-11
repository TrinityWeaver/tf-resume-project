terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "eu-west-2"
    profile = "tf-resume"
    key     = "tf-sebastian-resume-project"
    bucket  = "tf-sebastian-resume-project"

  }
}