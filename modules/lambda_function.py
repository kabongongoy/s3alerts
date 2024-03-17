# import json
# import boto3
# import os

# ses = boto3.client('ses')

# SENDER_EMAIL = os.environ['SENDER_EMAIL']
# RECEIVER_EMAIL = os.environ['RECEIVER_EMAIL']

# def lambda_handler(event, context):
#     try:
#         record = event['Records'][0]
#         bucket_name = record['s3']['bucket']['name']
#         object_key = record['s3']['object']['key']
        
#         subject = f"File Downloaded from S3 Bucket {bucket_name}"
#         body = f"The file '{object_key}' was downloaded from the S3 bucket {bucket_name}."
        
#         response = ses.send_email(
#             Source=SENDER_EMAIL,
#             Destination={
#                 'ToAddresses': [
#                     RECEIVER_EMAIL,
#                 ]
#             },
#             Message={
#                 'Subject': {
#                     'Data': subject
#                 },
#                 'Body': {
#                     'Text': {
#                         'Data': body
#                     }
#                 }
#             }
#         )
        
#         return {
#             'statusCode': 200,
#             'body': json.dumps('Email sent successfully')
#         }
#     except Exception as e:
#         error_message = f"An error occurred: {str(e)}"
#         print(error_message)
#         return {
#             'statusCode': 500,
#             'body': json.dumps(error_message)
#         }

import json
import boto3
import os
import requests

ses = boto3.client('ses')

SENDER_EMAIL = os.environ['SENDER_EMAIL']
RECEIVER_EMAIL = os.environ['RECEIVER_EMAIL']
SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"

def send_slack_alert(message):
    payload = {
        "text": message
    }
    response = requests.post(SLACK_WEBHOOK_URL, json=payload)
    if response.status_code != 200:
        raise Exception(f"Failed to send Slack alert. Status code: {response.status_code}")

def send_email_notification(subject, body):
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

def lambda_handler(event, context):
    try:
        record = event['Records'][0]
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        
        subject = f"File Downloaded from S3 Bucket {bucket_name}"
        body = f"The file '{object_key}' was downloaded from the S3 bucket {bucket_name}."
        
        # Send email notification
        send_email_notification(subject, body)
        
        # Send alert to Slack
        slack_message = f"File '{object_key}' downloaded from S3 bucket {bucket_name}"
        send_slack_alert(slack_message)
        
        return {
            'statusCode': 200,
            'body': json.dumps('Email sent successfully and Slack alert sent')
        }
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        print(error_message)
        return {
            'statusCode': 500,
            'body': json.dumps(error_message)
        }
