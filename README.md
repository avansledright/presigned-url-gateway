# Presigned URL Gateway

A serverless AWS infrastructure for generating secure, time-limited presigned URLs for S3 objects using API Gateway and Lambda.

## Architecture

- API Gateway endpoint that accepts GET requests
- Lambda function to generate presigned URLs
- S3 bucket with versioning enabled
- Frontend interface for direct S3 uploads and downloads
- Infrastructure defined using Terraform

## Requirements

- AWS Account
- Terraform ~> 5.0
- Python 3.11
- Node.js and npm
- Postman (for testing)

## Infrastructure Components

- **S3 Bucket**: Versioned storage bucket with CORS enabled
- **API Gateway**: REST API with a single GET endpoint `/getUrl`
- **Lambda Function**: Python 3.11 function to generate presigned URLs
- **IAM Roles**: Required permissions for Lambda to access S3
- **Frontend**: TypeScript-based web interface for direct S3 interaction

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

### Backend
1. Initialize Terraform:
```bash
terraform init
```

2. Deploy infrastructure:
```bash
terraform apply
```

### Frontend
1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```
AWS_REGION=your-region
AWS_ACCESS_KEY=your-access-key
AWS_SECRET_KEY=your-secret-key
S3_BUCKET=my-secure-storage-bucket
API_ENDPOINT=your-api-gateway-url
```

4. Build the frontend:
```bash
npm run build
```

5. Serve the frontend files using your preferred web server

## Security Features

- CORS enabled with appropriate headers
- URL expiration controls
- S3 bucket versioning
- Direct S3 uploads for large files
- Error handling for missing parameters and S3 errors

## Notes

- Default region: us-west-2
- Default URL expiration: 1 hour
- Cross-origin requests allowed
- Frontend supports direct S3 uploads to bypass API Gateway file size limitations