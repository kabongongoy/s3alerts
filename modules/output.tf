output "arn" {
  description = "ARN of the bucket"
  value       = data.aws_s3_bucket.selected.arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = data.aws_s3_bucket.selected.id
}
