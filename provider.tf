provider "aws" {
  #profile = var.profile
  region = var.region-master
  alias  = "region-master"
}


provider "aws" {
  #profile = var.profile
  region = var.region-virginia
  alias  = "region-virginia"
}


provider "aws" {
  #profile = var.profile
  region = var.region-ire
  alias  = "region-ire"
}
