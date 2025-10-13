# VPC Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

# EKS Cluster Outputs
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_region" {
  value = var.region
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

# IAM Roles Outputs
output "eks_cluster_iam_role_arn" {
  value = module.iam.cluster_iam_role_arn
}

output "eks_nodegroup_iam_role_arn" {
  value = module.iam.nodegroup_iam_role_arn
}

# Ingress Controller Outputs
output "nginx_ingress_status" {
  value = module.ingress.ingress_service
}

