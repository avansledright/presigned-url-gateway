# outputs.tf
output "api_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/getUrl"
  description = "API Gateway URL for the presigned URL endpoint"
}

output "bucket_name" {
  value = aws_s3_bucket.storage.id
  description = "Name of the created S3 bucket"
}

output "api_key_value" {
  value       = aws_api_gateway_api_key.presigned_url_key.value
  sensitive   = true
  description = "API Key for the presigned URL API"
}