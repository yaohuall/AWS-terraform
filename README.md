# AWS-terraform-k8s-demo
hands-on terraform code lauching AWS service + some k8s demo<br>

S3 - create AWS S3 with terraform <br>
kops - Dockerfile of kubectl, eksctl, kops environment <br>
k8s - psql + django k8s demo <br>
eks - create eks with terraform <br>

## k8s install notes
Before initialize kubeadm - close swap and disabled setting of ctl in `/etc/containerd/config.toml` <br>
CoreDNS crashloopback - add `nameserver 8.8.8.8` to `/etc/resolv.conf` 

## EKS install notes
Kubectl connects to EKS cluster <br>
`aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

## EKS security groups
In EKS, there are three types of sg: <br>
1. default sg: created after launch of cluster, if there is no other customized sg, EKS would use this sg as master-nodes communication.
2. customized sg: can be edited in Terraform, `resource "aws_security_group"`
3. primary sg: created after launch of cluster, the description of this sg is `EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads.` this is the sg for master-external communication. Can not be edited in Terraform, but can be edited in output of Terraform `aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id`

## EKS settings reference
### For EKS IAM role and policy settings <br>
https://catalog.us-east-1.prod.workshops.aws/workshops/4eab6682-09b2-43e5-93d4-1f58fd6cff6e/en-US/setupawsdeployment/iamroles
### For EKS public loadbalancer <br>
https://repost.aws/zh-Hant/knowledge-center/eks-vpc-subnet-discovery
### For EKS EMR pricing policy
https://aws.amazon.com/blogs/big-data/amazon-emr-on-amazon-eks-provides-up-to-61-lower-costs-and-up-to-68-performance-improvement-for-spark-workloads/

#### reference
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html <br>
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks <br>
https://aws.github.io/aws-eks-best-practices/networking/subnets/
