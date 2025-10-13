module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = var.public_subnet_ids
  vpc_id          = var.vpc_id
  cluster_iam_role_name = var.cluster_iam_role_arn
  node_groups = {
    eks_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type    = var.node_instance_type
      iam_role_arn     = var.node_group_iam_role_arn
    }
  }
  tags = {
    Environment = "dev"
  }
}

