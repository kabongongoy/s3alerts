variable "bucketName" {
  description = "Bucket name to create or refrence"
  type = string
  #default = "projects2024"
}


variable "sender_email" {
  type = string
  #default = "afaleye@gmail.com"
}

variable "receiver_email" {
  type = string
  #default = "afaleye@gmail.com"
}


variable "function_name" {
  type = string
  #default = "s3_download_notifier"
}

variable "events" {
  type = list(string)
  #default = [ "s3:ObjectCreated:*" ]
  
}

variable "runtime" {
  type = string
  #default = "python3.8"
}


variable "slack_webhook_url" {
  type = string
  #default = "https://hooks.slack.com/services/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"
}

variable "create_bucket" {
  type = bool
  #default = false
  
}


# SENDER_EMAIL = "afaleye@gmail.com"
# RECEIVER_EMAIL = "afaleye@gmail.com"   function_name