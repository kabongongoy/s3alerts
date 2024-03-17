provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

#Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucketName # Change this to your desired bucket name
  #acl    = "private"
  # lifecycle {
  #   precondition {
  #     condition     = var.create_bucket == true
  #     error_message = "This will create bucket if the variable value is true and error out if false in the variable declaration file"
  #   }
  # }
  
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = data.aws_s3_bucket.selected.id
  versioning_configuration {
    status = "Enabled"
  }
}



data "aws_s3_bucket" "selected" {
  bucket = var.bucketName
  depends_on = [ aws_s3_bucket.example_bucket ]
}

# Create an IAM role for Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  # Attach policies for S3 read access
  // Add policies for SES or SMTP access if needed
}


resource "aws_iam_policy" "ses_send_email_policy" {
  name        = "SES_SendEmail_Policy"
  description = "Allows Lambda to send emails via SES"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ses_send_email_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.ses_send_email_policy.arn
}


# Attach an IAM policy to the role to allow Lambda to write CloudWatch logs
resource "aws_iam_policy_attachment" "lambda_cloudwatch_policy" {
  name       = "lambda_cloudwatch_policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_execution_role.name]
}

# Create Lambda function
resource "aws_lambda_function" "s3_download_notifier" {
  filename         = "${path.module}/lambda_function.zip"
  function_name    = "s3_download_notifier"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
  #source_code_hash = filebase64sha256("lambda_function.zip")
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      SENDER_EMAIL = var.sender_email
      RECEIVER_EMAIL = var.receiver_email
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

# Configure S3 event notification to trigger Lambda function on object download
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_download_notifier.arn
  principal     = "s3.amazonaws.com"

  source_arn = data.aws_s3_bucket.selected.arn
}

# Create CloudWatch log group for Lambda logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}-${var.bucketName}"
  retention_in_days = 14
}

# Create the Lambda function code zip file
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source_dir  = "${path.module}/functions/"

}

# Configure S3 event notification to trigger Lambda function on object download
resource "aws_s3_bucket_notification" "example_bucket_notification" {
  bucket = data.aws_s3_bucket.selected.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_download_notifier.arn
    events              = var.events
  }
}

resource "aws_iam_policy" "lambda_slack_policy" {
  name        = "LambdaSlackPolicy"
  description = "Allows Lambda to send messages to Slack"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:CreateNetworkInterface",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeNetworkInterfaces",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DeleteNetworkInterface",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:DeleteObject",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeAsync",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:PutEvents",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:PutRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DeleteRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DescribeRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DescribeRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DescribeRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DescribeRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DescribeRule",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:RemoveTargets",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "events:DeleteRule",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_slack_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_slack_policy.arn
}
