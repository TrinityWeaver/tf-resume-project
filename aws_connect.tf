# Amazon Connect


data "aws_ssm_parameter" "connect_alias" {
  provider = aws.region-master
  name     = "/resume/connect/friendly-alias"
}



resource "aws_connect_instance" "sebastian_connect" {
  provider                         = aws.region-master
  identity_management_type         = "CONNECT_MANAGED"
  inbound_calls_enabled            = true
  instance_alias                   = data.aws_ssm_parameter.connect_alias.value
  outbound_calls_enabled           = true
  contact_lens_enabled             = false
  auto_resolve_best_voices_enabled = false
  early_media_enabled              = false
}
