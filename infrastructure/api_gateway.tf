# API Gateway
resource "aws_api_gateway_rest_api" "presigned_url_api" {
  name = "presigned-url-api"
}

resource "aws_api_gateway_resource" "presigned_url" {
  rest_api_id = aws_api_gateway_rest_api.presigned_url_api.id
  parent_id   = aws_api_gateway_rest_api.presigned_url_api.root_resource_id
  path_part   = "getUrl"
}

resource "aws_api_gateway_method" "presigned_url" {
  rest_api_id   = aws_api_gateway_rest_api.presigned_url_api.id
  resource_id   = aws_api_gateway_resource.presigned_url.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.presigned_url_api.id
  resource_id = aws_api_gateway_resource.presigned_url.id
  http_method = aws_api_gateway_method.presigned_url.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.presigned_url.invoke_arn
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.presigned_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.presigned_url_api.execution_arn}/*"
}

resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.presigned_url_api.id
  resource_id = aws_api_gateway_resource.presigned_url.id
  http_method = aws_api_gateway_method.presigned_url.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Deployment
resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.presigned_url_api.id
  depends_on  = [aws_api_gateway_integration.lambda]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.prod.id
  rest_api_id  = aws_api_gateway_rest_api.presigned_url_api.id
  stage_name   = "prod"
}