output "cluster_iam_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "nodegroup_iam_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

