provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {}
variable "aws_account_id" {}
variable "aws_cognito_identity_pool_id" {}

variable "aws_api_gateway_rest_api_id" {}
variable "aws_api_gateway_resource_parent" {}
variable "aws_api_gateway_resource_parent_path" {}