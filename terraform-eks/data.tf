data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_instances" "worker" {
  instance_tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "owned"
  }
  instance_state_names = ["running"]
  depends_on           = [aws_eks_node_group.nodes]
}