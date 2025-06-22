terraform {
  backend "s3" {
    bucket = "rearc-tfstate-abcd"
    key = "admin/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}
