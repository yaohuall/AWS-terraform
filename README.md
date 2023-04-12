# AWS-terraform-minimal-implementation
hands-on terraform code lauching AWS services<br>

S3 - create AWS S3 with terraform <br>
kops - Dockerfile of kubectl, eksctl, kops environment <br>
eks - create eks with terraform <br>

**Change AWS region using aws cli `--region` tag**

## k8s install notes
Before initialize kubeadm - close swap and disabled setting of ctl in `/etc/containerd/config.toml` <br>
CoreDNS crashloopback - add `nameserver 8.8.8.8` to `/etc/resolv.conf` 

## EC2 config
**EBS root volume**: When you launch an instance, the root device volume contains the image used to boot the instance. When we introduced Amazon EC2, all AMIs were backed by Amazon EC2 instance store, which means the root device for an instance launched from the AMI is an instance store volume created from a template stored in Amazon S3. After we introduced Amazon EBS, we introduced AMIs that are backed by Amazon EBS. This means that the root device for an instance launched from the AMI is an Amazon EBS volume created from an Amazon EBS snapshot.

## EKS install notes
Kubectl connects to EKS cluster <br>
`aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

## EKS security groups
In EKS, there are three types of sg: <br>
1. **default sg**: created after launch of cluster, if there is no other customized sg, EKS would use this sg as master-nodes communication.
2. **customized sg**: can be edited in Terraform, `resource "aws_security_group"`
3. **primary sg**: created after launch of cluster, the description of this sg is `EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads.` this is the sg for master-external communication. Can not be edited in Terraform, but can be edited in output of Terraform `aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id`

## EKS settings reference
1. **For EKS IAM role and policy settings** <br>
https://catalog.us-east-1.prod.workshops.aws/workshops/4eab6682-09b2-43e5-93d4-1f58fd6cff6e/en-US/setupawsdeployment/iamroles
2. **For EKS public loadbalancer** <br>
https://repost.aws/zh-Hant/knowledge-center/eks-vpc-subnet-discovery
3. **For EKS EMR pricing policy** <br>
https://aws.amazon.com/blogs/big-data/amazon-emr-on-amazon-eks-provides-up-to-61-lower-costs-and-up-to-68-performance-improvement-for-spark-workloads/

## EMR submit a test file
### copy the test file to your bucket
    aws s3 cp s3://us-east-1.elasticmapreduce/emr-containers/samples/wordcount/scripts/wordcount.py s3://{your-bucket-name}/scripts/ --region us-east-1

### submit your spark job to cluster
    aws emr-serverless start-job-run --application-id {your-application-id} --execution-role-arn {your-emr-role-arn} --name "spark-test" --job-driver '{"sparkSubmit":{"entryPoint":"s3://{your-bucket-name}/scripts/wordcount.py", "entryPointArguments":["s3://{your-bucket-name}/output"], "sparkSubmitParameters": "--conf spark.executor.cores=1 --conf spark.executor.memory=4g --conf spark.driver.cores=1 --conf spark.driver.memory=4g --conf spark.executor.instances=1"}}' --region {your-region}

## EMR serverless reference
1. **using terraform** <br> 
https://github.com/terraform-aws-modules/terraform-aws-emr/tree/v1.0.0/examples/serverless-cluster <br>
2. **EMR serverless iam role & submit config** <br>
https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/jobs-spark.html <br>
3. **Use Python packages** <br>
https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html <br>

#### reference
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/RootDeviceStorage.html <br>
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks <br>
https://aws.github.io/aws-eks-best-practices/networking/subnets/ <br>
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group <br>
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group <br>


