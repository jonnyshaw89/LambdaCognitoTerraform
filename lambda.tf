// Auth
resource "aws_lambda_function" "createUser" {
  filename = "${path.module}/Lambda/Auth/CreateUser.zip"
  function_name = "LambdAuthCreateUser"
  role = "${aws_iam_role.LambdAuthCreateUser.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/CreateUser.zip"))}"
}

resource "aws_lambda_function" "changePassword" {
  filename = "${path.module}/Lambda/Auth/ChangePassword.zip"
  function_name = "LambdAuthChangePassword"
  role = "${aws_iam_role.LambdAuthChangePassword.arn}"
  handler = "index.handler"
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
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/LostPassword.zip"))}"
}

resource "aws_lambda_function" "resetPassword" {
  filename = "${path.module}/Lambda/Auth/ResetPassword.zip"
  function_name = "LambdAuthResetPassword"
  role = "${aws_iam_role.LambdAuthResetPassword.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/ResetPassword.zip"))}"
}

resource "aws_lambda_function" "verifyUser" {
  filename = "${path.module}/Lambda/Auth/VerifyUser.zip"
  function_name = "LambdAuthVerifyUser"
  role = "${aws_iam_role.LambdAuthVerifyUser.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${path.module}/Lambda/Auth/VerifyUser.zip"))}"
}