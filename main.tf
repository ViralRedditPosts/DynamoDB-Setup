terraform {
  required_providers {}

  required_version = ">= 1.2.0"
}

module "dynamodb-table-rising-dev" {
  source = "./modules/dynamodb"

  env = "dev"
  reddit_view = "rising"
}

module "dynamodb-table-hot-dev" {
  source = "./modules/dynamodb"

  env = "dev"
  reddit_view = "hot"
}

