terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

variable "table_fields" {
  type = map(string)
  default = {
    loadDateUTC    = "S"
    loadTimeUTC    = "S"
    loadTSUTC      = "S"
    postId         = "S"
  }
}

resource "aws_dynamodb_table" "hot-dynamodb-table-dev" {
  name           = "hot-dev"
  billing_mode   = "PROVISIONED"
  read_capacity  = 6
  write_capacity = 1
  hash_key       = "postId"
  range_key      = "loadTSUTC"

  # dynamic blocks https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
  dynamic "attribute" {
    for_each = var.table_fields
    content {
      name   = attribute.key
      type = attribute.value
    }
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "byLoadDate"
    hash_key           = "loadDateUTC"
    range_key          = "loadTimeUTC"
    write_capacity     = 6
    read_capacity      = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-hot"
    Environment = "dev"
    Project     = "viral-reddit-posts"
  }
}
