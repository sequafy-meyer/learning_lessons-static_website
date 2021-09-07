output "s3_bucket_url" {
  value       = aws_s3_bucket.static_website.website_endpoint
  description = "URL of the S3 bucket"
}