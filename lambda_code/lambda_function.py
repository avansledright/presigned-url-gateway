# lambda_function.py
import boto3
import json
import os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Get the query parameters
    query_params = event.get('queryStringParameters', {})
    if not query_params or 'key' not in query_params:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Missing required parameter: key'})
        }
    
    object_key = query_params['key']
    expiration = int(query_params.get('expiration', 3600))  # Default 1 hour
    
    # Initialize S3 client
    s3_client = boto3.client('s3')
    bucket_name = os.environ['BUCKET_NAME']
    
    try:
        # Generate presigned URL
        url = s3_client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucket_name,
                'Key': object_key
            },
            ExpiresIn=expiration
        )
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'url': url,
                'expires_in': expiration
            })
        }
        
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }