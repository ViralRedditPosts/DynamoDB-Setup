terraform {
  required_providers {}

  required_version = ">= 1.2.0"
}

variable "info" {
  type = map(string)
  default = {
    name = "viralredditposts"
    env = "dev"
  }
}

# get account id
data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

##################
# DynamoDB Setup #
##################
module "dynamodb-table-rising-dev" {
  source = "./modules/dynamodb"

  env = "${var.info.env}"
  reddit_view = "rising"
}

module "dynamodb-table-hot-dev" {
  source = "./modules/dynamodb"

  env = "${var.info.env}"
  reddit_view = "hot"
}

############
# S3 Setup #
############
# create s3 resource
resource "aws_s3_bucket" "data-bucket" {
  bucket = "data-${var.info.name}-${var.info.env}-${local.account_id}"
  force_destroy = true

  tags = {
    Name        = "data-${var.info.name}-${var.info.env}-${local.account_id}"
    Environment = "${var.info.env}"
    Project     = "viral-reddit-posts"
  }
}

# this is mainly for storing the PRAW package for the Lambda Function
resource "aws_s3_bucket" "packages-bucket" {
  bucket = "packages-${var.info.name}-${var.info.env}-${local.account_id}"
  force_destroy = true

  tags = {
    Name        = "packages-${var.info.name}-${var.info.env}-${local.account_id}"
    Environment = "${var.info.env}"
    Project     = "viral-reddit-posts"
  }
}

# copy config file to s3
resource "aws_s3_object" "reddit-cfg" {
  # depends_on = [ aws_s3_bucket.data-bucket ]

  bucket = aws_s3_bucket.data-bucket.id 
  key    = "reddit.cfg"
  source = "./reddit.cfg"
  tags = {
    Name        = "config-file"
    Environment = "${var.info.env}"
    Project     = "viral-reddit-posts"
  }
}
