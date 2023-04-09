terraform {
	required_providers {
		aws = {
	    version = "~> 4.39.0"
		}
  }
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "crossrt"
}
