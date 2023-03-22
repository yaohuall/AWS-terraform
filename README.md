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
    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

### simply run a AWS EKS using eksctl(not recommended)
    eksctl create cluster --name test-cluster --region us-east-2 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2
  
#### reference
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html <br>
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks <br>

