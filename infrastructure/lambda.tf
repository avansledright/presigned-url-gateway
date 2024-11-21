# Lambda
resource "aws_lambda_function" "presigned_url" {
  filename         = local.lambda_zip_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  function_name    = "generate_presigned_url"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.11"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.storage.id
    }
  }
}