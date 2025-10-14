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
  backend "s3" {
    bucket       = "ekscluster-terraform-state-hrgf"
    key          = "eks/my-cluster/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
