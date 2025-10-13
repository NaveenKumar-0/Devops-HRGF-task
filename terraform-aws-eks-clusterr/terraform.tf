terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10"
    }
  }
  /* backend "s3" {
   bucket = "mybucket"
   key    = "path/to/my/key"
   region = "us-east-1"
   use_lockfile = true
  } */
}
