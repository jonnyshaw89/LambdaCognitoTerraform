// API Gateway

// /auth
resource "aws_api_gateway_resource" "Auth" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  parent_id = "${var.aws_api_gateway_resource_parent}"
  path_part = "auth"
}

// /auth
resource "aws_api_gateway_resource" "Signup" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  parent_id = "${aws_api_gateway_resource.Auth.id}"
  path_part = "signup"
}

// /Signup OPTIONS
resource "aws_api_gateway_method" "Signup-OPTIONS" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "Signup-OPTIONS-Integration" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.Signup-OPTIONS.http_method}"
  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "Signup-OPTIONS-Integration-Response" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.Signup-OPTIONS.http_method}"
  status_code = "${aws_api_gateway_method_response.Signup-OPTIONS-200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method_response" "Signup-OPTIONS-200" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.Signup-OPTIONS.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}


// /signup POST
resource "aws_api_gateway_method" "signup-POST" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = "${aws_api_gateway_model.generator_request_model.name}"
  }
}

resource "aws_api_gateway_model" "generator_request_model" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  name = "Configuration"
  description = "A configuration schema"
  content_type = "application/json"
  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "GeneratorConfiguration",
  "type": "array",
  "properties": {
    "email": { "type": "string" },
    "password": { "type": "string" }
  }
}
EOF
}

resource "aws_api_gateway_integration" "Auth-createUser-integration" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.createUser.arn}/invocations"
  integration_http_method = "POST"
  request_templates = {                  # Not documented
    "application/json" = "${file("${path.module}/templates/Auth-createUser-integration.template")}"
  }
}

resource "aws_api_gateway_method_response" "signup-POST-200" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "signup-POST-Integration-Response" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  status_code = "${aws_api_gateway_method_response.signup-POST-200.status_code}"
}
