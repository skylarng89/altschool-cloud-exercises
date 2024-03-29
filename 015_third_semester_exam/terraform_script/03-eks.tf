resource "aws_iam_role" "EKS-Cluster-Role" {
  name = "EKS-Cluster-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKS-Cluster-Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.EKS-Cluster-Role.name
}

resource "aws_iam_role" "Node-Group-Role" {
  name = "EKS-Node-Group-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Node-Group-Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.Node-Group-Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Node-Group-Role.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.EKS-Cluster-Role.arn

  vpc_config {
    security_group_ids = [aws_security_group.clustersg.id, aws_security_group.node-clustersg.id]
    subnet_ids         = flatten([module.vpc.private_subnets, module.vpc.private_subnets])

  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    module.vpc,
    aws_security_group.clustersg,
    aws_security_group.node-clustersg,
  ]

}

resource "aws_eks_node_group" "node-1" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "node-1"
  node_role_arn   = aws_iam_role.Node-Group-Role.arn
  subnet_ids      = flatten(module.vpc.private_subnets)

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    module.vpc,
    aws_security_group.clustersg,
    aws_security_group.node-clustersg,
  ]

  tags = {
    node_group = "node-1"
  }

}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks-cluster.name
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks-cluster.name
}
