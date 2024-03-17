variable "bucketName" {
  type = string
  #default = "projects2024"
  description = "Name of the s3 bucket. Must be unique if not existing bucket."
}


variable "sender_email" {
  description = "Email address to use for the alert"
  type = string
  #default = "youremail@example.com" 
}

variable "receiver_email" {
  description = "Email address to forward the alert"
  type = string
  #default = "youremail@example.com"   
}


variable "function_name" {
  description = "The name of the lambda function"
  type = string
  #default = "s3_download_notifier" #
}

variable "events" {
  description = "List of s3 events to send notifications on"
  type = list(string)
  #default = [ "s3:ObjectCreated:*" ]
  
}

variable "runtime" {
  description = "python runtime version to use for lambda"
  type = string
  #default = "python3.8"
}



variable "create_bucket" {
  description = "if you want to create a new bucket"
  type = bool
  #default = false # Set to true if bucket needs to be created or false for already created bucket
}

