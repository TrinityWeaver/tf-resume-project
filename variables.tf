variable "region-master" {
  type    = string
  default = "eu-west-2"
}

variable "region-virginia" {
  type    = string
  default = "us-east-1"
}

variable "region-ire" {
  type    = string
  default = "eu-west-1"
}



variable "profile" {
  type    = string
  default = "private-sebastian"
}


variable "websites-name" {
  type    = string
  default = "www"
}

variable "info_email" {
  type    = string
  default = "info@sebastianmarynicz.co.uk"
}

variable "lambda_role_SES_Forwarder" {
  type    = string
  default = "SesForwarder-dev-eu-west-1-lambdaRole"
}


variable "recipient_contact_SES_Forwarder" {
  type    = string
  default = "contact@sebastianmarynicz.co.uk"
}

variable "recipient_powershell_SES_Forwarder" {
  type    = string
  default = "powershell-is-trash@sebastianmarynicz.co.uk"
}

variable "recipient_admin_SES_Forwarder_ire" {
  type    = string
  default = "admin@sebastianmarynicz.co.uk"

}
