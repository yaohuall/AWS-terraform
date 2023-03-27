resource "aws_eks_cluster" "cluster" {
    name     = "data-cluster"
    version  = "1.24"
    # ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to 
    # AWS API operations on your behalf. 
    role_arn = aws_iam_role.cluster_role.arn

    vpc_config {
    # access eks from local
    endpoint_public_access = true
    subnet_ids = [
        #   aws_subnet.private_ap_east_1a.id,
        #   aws_subnet.private_ap_east_1b.id,
            aws_subnet.public_ap_east_1a.id,
            aws_subnet.public_ap_east_1b.id
        ]
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
    # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
    depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "nodes" {
    version = "1.24"
    cluster_name    = aws_eks_cluster.cluster.name
    node_group_name = "data-nodes"
    node_role_arn   = aws_iam_role.node_role.arn

    # Single subnet to avoid data transfer charges while testing.
    subnet_ids = [
        aws_subnet.public_ap_east_1a.id
    ]

    # use spot in testing, ON_DEMAND in production
    capacity_type  = "SPOT"
    instance_types = ["t3.medium"]
    ami_type = "AL2_x86_64"
    disk_size = 20 

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 2
    }

    force_update_version = false 

    update_config {
        max_unavailable = 1
    }

    labels = {
        role = "worker"
    }

    tags = {
        "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "owned"
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}
