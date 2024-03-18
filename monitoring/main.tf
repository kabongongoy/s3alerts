
# Define AWS provider
provider "aws" {
  region = "us-east-1" # Set your desired region
}



module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 5.0"

  sns_topic_name = "s3-downloads"

  slack_webhook_url = "https://hooks.slack.com/services/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"
  
  slack_channel     = "random"
  slack_username    = "kabongo ngoy"
}
module "s3_monitoring" {
  source  = "./modules/s3"
  topic_arn = module.notify_slack.this_slack_topic_arn
  email_address = var.email_address
  bucketName = var.bucketName
  events = var.events
}
