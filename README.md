# DynamoDB-Setup

This repo contains code necessary to spin up DynamoDB resources for this project.

## How to use

1. Installs - see the [prerequisites section on this page](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#prerequisites) for additional information, the steps are essentially:
    1. Install Terraform CLI
    2. Install AWS CLI and run `aws configure` and enter in your aws credentials.
2. Clone this repository 
3. From within this repository run the following:
  
    ```sh
    terraform init
    terraform apply
    ```
    If you don't want to apply the changes to your aws account you can instead run `terraform plan`.