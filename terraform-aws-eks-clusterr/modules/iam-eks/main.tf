resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_cluster_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
  depends_on = [aws_iam_role.eks_cluster_role]
}

# Attach Service Policy
resource "aws_iam_role_policy_attachment" "eks_vpc_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
  depends_on = [aws_iam_role.eks_cluster_role]
}

# Attach EKS Console View Policy
resource "aws_iam_role_policy_attachment" "eks_console_view" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSViewPolicy"
  role       = aws_iam_role.eks_cluster_role.name
  depends_on = [aws_iam_role.eks_cluster_role]
}


resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Worker Node Policy
resource "aws_iam_role_policy_attachment" "eks_worker_attach1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
  depends_on = [aws_iam_role.eks_node_role]
}

# Attach CNI Policy
resource "aws_iam_role_policy_attachment" "eks_cni_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
  depends_on = [aws_iam_role.eks_node_role]
}

# Attach ECR ReadOnly Policy
resource "aws_iam_role_policy_attachment" "eks_ecr_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
  depends_on = [aws_iam_role.eks_node_role]
}
