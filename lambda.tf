// Auth
resource "aws_lambda_function" "createUser" {
  filename = "${path.module}/Lambda/Auth/CreateUser.zip"
  function_name = "LambdAuthCreateUser"
  role = "${aws_iam_role.LambdAuthCreateUser.arn}"
  handler = "CreateUser.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/CreateUser.zip"))}"
}

resource "aws_lambda_permission" "allow_api_gateway-createUser" {
  function_name = "${aws_lambda_function.createUser.function_name}"
  statement_id = "AllowCreateUserExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.aws_api_gateway_rest_api_id}/*/*/"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.aws_api_gateway_rest_api_id}/*/${aws_api_gateway_integration.Auth-createUser-integration.integration_http_method}${var.aws_api_gateway_resource_parent_path}${aws_api_gateway_resource.Auth.path}${aws_api_gateway_resource.Signup.path}"
}

resource "aws_lambda_function" "changePassword" {
  filename = "${path.module}/Lambda/Auth/ChangePassword.zip"
  function_name = "LambdAuthChangePassword"
  role = "${aws_iam_role.LambdAuthChangePassword.arn}"
  handler = "ChangePassword.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/ChangePassword.zip"))}"
}

resource "aws_lambda_function" "login" {
  filename = "${path.module}/Lambda/Auth/Login.zip"
  function_name = "LambdAuthLogin"
  role = "${aws_iam_role.LambdAuthLogin.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/Login.zip"))}"
}

resource "aws_lambda_function" "lostPassword" {
  filename = "${path.module}/Lambda/Auth/LostPassword.zip"
  function_name = "LambdAuthLostPassword"
  role = "${aws_iam_role.LambdAuthLostPassword.arn}"
  handler = "LostPassword.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/LostPassword.zip"))}"
}

resource "aws_lambda_function" "resetPassword" {
  filename = "${path.module}/Lambda/Auth/ResetPassword.zip"
  function_name = "LambdAuthResetPassword"
  role = "${aws_iam_role.LambdAuthResetPassword.arn}"
  handler = "ResetPassword.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/ResetPassword.zip"))}"
}

resource "aws_lambda_function" "verifyUser" {
  filename = "${path.module}/Lambda/Auth/VerifyUser.zip"
  function_name = "LambdAuthVerifyUser"
  role = "${aws_iam_role.LambdAuthVerifyUser.arn}"
  handler = "VerifyUser.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/VerifyUser.zip"))}"
}