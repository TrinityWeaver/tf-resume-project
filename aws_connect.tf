# Amazon Connect


resource "aws_connect_instance" "test" {
  provider                         = aws.region-master
  identity_management_type         = "CONNECT_MANAGED"
  inbound_calls_enabled            = true
  instance_alias                   = "sebastian-connect-instance"
  outbound_calls_enabled           = false
  contact_lens_enabled             = false
  auto_resolve_best_voices_enabled = false
  early_media_enabled              = false
}
