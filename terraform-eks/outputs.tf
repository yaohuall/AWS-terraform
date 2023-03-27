output "VPC_ID" {
  description = "Kubernetes Cluster VPC ID"
  value       = aws_vpc.main.id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.cluster.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.cluster.name
}

output "Nodes" {
  value = { for i in range(length(data.aws_instances.worker.ids)) : data.aws_instances.worker.ids[i] => data.aws_instances.worker.private_ips[i] }
}