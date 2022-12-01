terraform {
  backend "s3" {
    bucket  = "test-terraform-states-templete"
    key     = "./dev_terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
    //kms_key_id              = "alias/test-templete-infra-key"
    //dynamodb_table          = "terraform-state"
    shared_credentials_file = "./../credentials_dev"
    profile                 = "default"
  }
}