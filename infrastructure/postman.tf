resource "local_file" "postman_collection" {
  filename = "${path.module}/postman_collection.json"
  content  = jsonencode(local.postman_template)

  depends_on = [aws_api_gateway_stage.prod]
}