variable "bucketName" {
  type = string
  # default = "add_your_bucketname_here"
}

variable "email_address" {
  type = string
  # default = "email_to_forward_notifications"
}

variable "topic_arn" {
  type = string
  # default = "module.notify_slack.this_slack_topic_arn"

}

variable "events" {
  type = list(string)
  # default = [ "s3:ObjectCreated:*" ]
}