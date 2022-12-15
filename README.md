# AWS-terraform-k8s-demo
git remote name: terraform

## terraform init
  terraform init

## terraform check code validation
  terraform validate

## terraform launch S3 cloud service
  terraform apply

### simply run a AWS EKS using eksctl
  eksctl create cluster --name test-cluster --region us-east-2 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2
  
#### reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#force_destroy
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
