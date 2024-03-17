import json
import boto3
import os

ses = boto3.client('ses')

SENDER_EMAIL = os.environ['SENDER_EMAIL']
RECEIVER_EMAIL = os.environ['RECEIVER_EMAIL']

def lambda_handler(event, context):
    try:
        record = event['Records'][0]
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        
        subject = f"File Downloaded from S3 Bucket {bucket_name}"
        body = f"The file '{object_key}' was downloaded from the S3 bucket {bucket_name}."
        
        response = ses.send_email(
            Source=SENDER_EMAIL,
            Destination={
                'ToAddresses': [
                    RECEIVER_EMAIL,
                ]
            },
            Message={
                'Subject': {
                    'Data': subject
                },
                'Body': {
                    'Text': {
                        'Data': body
                    }
                }
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Email sent successfully')
        }
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        print(error_message)
        return {
            'statusCode': 500,
            'body': json.dumps(error_message)
        }

