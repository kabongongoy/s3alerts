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


variable "create_bucket" {
  type = bool
  #default = false
  
}


# SENDER_EMAIL = "afaleye@gmail.com"
# RECEIVER_EMAIL = "afaleye@gmail.com"   function_name