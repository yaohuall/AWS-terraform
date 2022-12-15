# AWS-terraform-k8s-demo
hands-on terraform code lauching AWS service
git remote name: terraform

### simply run a AWS EKS using eksctl
    eksctl create cluster --name test-cluster --region us-east-2 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2
  
#### reference
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
