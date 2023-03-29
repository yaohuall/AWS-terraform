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

## EKS settings reference
### For EKS IAM role and policy settings <br>
`https://catalog.us-east-1.prod.workshops.aws/workshops/4eab6682-09b2-43e5-93d4-1f58fd6cff6e/en-US/setupawsdeployment/iamroles`
### For EKS public loadbalancer <br>
`https://repost.aws/zh-Hant/knowledge-center/eks-vpc-subnet-discovery`
### For EKS EMR pricing policy
`https://aws.amazon.com/blogs/big-data/amazon-emr-on-amazon-eks-provides-up-to-61-lower-costs-and-up-to-68-performance-improvement-for-spark-workloads/`

#### reference
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html <br>
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks <br>
https://aws.github.io/aws-eks-best-practices/networking/subnets/
