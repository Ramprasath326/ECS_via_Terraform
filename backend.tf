terraform {
  backend "s3" {
    bucket = "ram-s3-demo-21032026"
    key    = "ramprasath/terraform.tfstate"
    region = "us-east-2"
  }
}