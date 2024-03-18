variable "bucketName" {
  type = string
  # default = "add_your_bucketname_here"
}

variable "email_address" {
  type = string
  # default = "email_to_forward_notifications"
}

variable "events" {
  type = list(string)
  # default = [ "s3:ObjectCreated:*" ]
}