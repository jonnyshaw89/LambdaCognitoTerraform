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
  parent_id = "${var.aws_api_gateway_resource_parent}"
  path_part = "signup"
}


// /signup POST
resource "aws_api_gateway_method" "signup-POST" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Signup.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "Auth-createAuth-integration" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Auth.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.createUser.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "Auth-POST-200" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Auth.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "Auth-POST-Integration-Response" {
  rest_api_id = "${var.aws_api_gateway_rest_api_id}"
  resource_id = "${aws_api_gateway_resource.Auth.id}"
  http_method = "${aws_api_gateway_method.signup-POST.http_method}"
  status_code = "${aws_api_gateway_method_response.Auth-POST-200.status_code}"
}
