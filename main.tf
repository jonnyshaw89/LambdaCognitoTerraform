provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {}
variable "aws_account_id" {}
variable "aws_cognito_identity_pool_id" {}