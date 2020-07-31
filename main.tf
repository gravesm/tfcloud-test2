terraform {
  backend "remote" {
    organization = "gravesmj"
    workspaces {
      prefix = "remote-test-"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

data "terraform_remote_state" "foo" {
  backend = "remote"

  config = {
    organization = "gravesmj"
    workspaces = {
      name = "mgraves-${var.workspace}"
    }
  }
}

resource "aws_iam_user" "default" {
  name = "tf-remote-test-${var.workspace}"
  tags = {
    foo = data.terraform_remote_state.foo.outputs.name
  }
}
