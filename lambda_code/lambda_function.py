import boto3
import json
import os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key',
        'Access-Control-Allow-Methods': 'GET,OPTIONS'
    }
    
    query_params = event.get('queryStringParameters', {})
    if not query_params or 'key' not in query_params:
        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': 'Missing required parameter: key'})
        }
    
    s3_client = boto3.client('s3')
    bucket_name = os.environ['BUCKET_NAME']
    
    try:
        url = s3_client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucket_name,
                'Key': query_params['key']
            },
            ExpiresIn=3600
        )
        
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({
                'url': url,
                'expires_in': 3600
            })
        }
    except ClientError as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }