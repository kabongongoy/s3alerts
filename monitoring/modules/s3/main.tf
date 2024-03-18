
resource "aws_sns_topic_policy" "default" {
  #arn = module.notify_slack.this_slack_topic_arn
  arn = var.topic_arn

  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "${var.topic_arn}",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.example_bucket.arn}"}
          }
      }]
  }
  POLICY
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = var.topic_arn
  protocol  = "email"
  endpoint  = var.email_address
}


# Define S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucketName
}

# Define S3 bucket notification configuration
resource "aws_s3_bucket_notification" "example_notification" {
  bucket = aws_s3_bucket.example_bucket.id
  topic {
    topic_arn = var.topic_arn
    events    = var.events
  }
}

