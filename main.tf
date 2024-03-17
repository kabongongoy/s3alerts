provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}




module "aws_s3_bucket_monitoring" {
  source = "./modules/"
  bucketName = var.bucketName
  sender_email = var.sender_email
  receiver_email = var.receiver_email
  function_name = var.function_name
  events = var.events
  runtime = var.runtime
  create_bucket = var.create_bucket
}

