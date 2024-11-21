locals {
    lambda_src_path = "../lambda_code/lambda_function.py"
    lambda_zip_path = "${path.module}/lambda_function.zip"

    postman_template = {
        info = {
            name   = "S3 Presigned URL API"
            schema = "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        }
        item = [
            {
            name    = "Get Presigned URL"
            request = {
                method = "GET"
                header = []
                url = {
                raw  = "${aws_api_gateway_stage.prod.invoke_url}/getUrl?key=test.jpg&expiration=3600"
                host = ["${aws_api_gateway_stage.prod.invoke_url}/getUrl"]
                query = [
                    {
                    key         = "key"
                    value       = "test.jpg"
                    description = "S3 object key"
                    },
                    {
                    key         = "expiration"
                    value       = "3600"
                    description = "URL expiration in seconds"
                    }
                ]
                }
            }
            }
        ]
  }
}