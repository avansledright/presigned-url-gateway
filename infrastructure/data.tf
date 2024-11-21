data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = local.lambda_src_path
  output_path = local.lambda_zip_path
}