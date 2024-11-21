# Presigned URL Gateway

A serverless AWS infrastructure for generating secure, time-limited presigned URLs for S3 objects using API Gateway and Lambda.

## Architecture

- API Gateway endpoint that accepts GET requests
- Lambda function to generate presigned URLs
- S3 bucket with versioning enabled
- Infrastructure defined using Terraform

## Requirements

- AWS Account
- Terraform ~> 5.0
- Python 3.11
- Postman (for testing)

## Infrastructure Components

- **S3 Bucket**: Versioned storage bucket for objects
- **API Gateway**: REST API with a single GET endpoint `/getUrl`
- **Lambda Function**: Python 3.11 function to generate presigned URLs
- **IAM Roles**: Required permissions for Lambda to access S3

## API Usage

### GET /getUrl

Query Parameters:
- `key` (required): Object key in S3 bucket
- `expiration` (optional): URL expiration time in seconds (default: 3600)

Response:
```json
{
    "url": "https://presigned-url...",
    "expires_in": 3600
}
```

## Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Deploy infrastructure:
```bash
terraform apply
```

3. A Postman collection is automatically generated for testing.

## Security Features

- CORS enabled with appropriate headers
- URL expiration controls
- S3 bucket versioning
- Error handling for missing parameters and S3 errors

## Notes

- Default region: us-west-2
- Default URL expiration: 1 hour
- Cross-origin requests allowed