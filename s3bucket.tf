data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}.static-website-${random_pet.bucket_pet.id}"
}

resource "random_pet" "bucket_pet" {}

resource "aws_s3_bucket" "static_website" {
  acl    = "public-read"
  bucket = local.bucket_name

  policy = templatefile("templates/s3_bucket_policy.tpl",{
      bucket_name = local.bucket_name
    })

  tags = merge(
    var.tags,
    {
      Name = "static-website-${random_pet.bucket_pet.id}"
    },
  )

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "index_document" {
  bucket       = aws_s3_bucket.static_website.id
  content_type = "text/html"
  etag         = filemd5("files/index.html")
  key          = "index.html"
  source       = "files/index.html"
}

resource "aws_s3_bucket_object" "unicorn_picture" {
  bucket       = aws_s3_bucket.static_website.id
  content_type = "image/jpeg"
  etag         = filemd5("files/unicorn.jpg")
  key          = "unicorn.jpg"
  source       = "files/unicorn.jpg"
}

resource "aws_s3_bucket_object" "stylesheet" {
  bucket       = aws_s3_bucket.static_website.id
  content_type = "text/css"
  etag         = filemd5("files/style.css")
  key          = "style.css"
  source       = "files/style.css"
}