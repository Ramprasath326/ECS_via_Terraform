terraform {
  backend "s3" {
    bucket         = "terraform-backend-statefile-gojo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}