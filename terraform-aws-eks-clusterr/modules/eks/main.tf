resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_iam_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids = var.public_subnet_ids
  }

  depends_on = [var.cluster_iam_role_arn]
}

resource "aws_security_group" "worker_nodes_sg" {
  name        = "${var.cluster_name}-worker-sg"
  description = "EKS worker nodes security group"
  vpc_id      = var.vpc_id

  # NodePort access for Prometheus/Grafana (example ports)
  ingress {
    description = "Allow NodePort range for monitoring"
    from_port   = 30800
    to_port     = 30900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or restrict to your IPs
  }

  # Optional: allow SSH if needed
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-worker-sg"
  }
}


resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_group_iam_role_arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]
  # Attach the new SG
  resources_vpc_config {
    subnet_ids         = var.public_subnet_ids
    security_group_ids = [aws_security_group.worker_nodes_sg.id]
  }
  depends_on = [aws_eks_cluster.this]
}

