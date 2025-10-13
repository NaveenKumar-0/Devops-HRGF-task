module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source       = "./modules/iam-eks"
  cluster_name = var.cluster_name
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  node_instance_type  = var.node_instance_type
  desired_capacity    = var.desired_capacity
  max_capacity        = var.max_capacity
  min_capacity        = var.min_capacity
  cluster_iam_role_arn  = module.iam.cluster_iam_role_arn
  node_group_iam_role_arn = module.iam.nodegroup_iam_role_arn
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

module "ingress" {
  source = "./modules/ingress-controller"
}

