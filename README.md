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

# AWS S3
### Use resource based policy(bucket policy) to give permission to principals
    data "aws_iam_policy_document" "allow_audit_logging" {
      statement {
        # sid    = "Put bucket policy needed for audit logging"
        effect = "Allow"

        principals {
          type        = "AWS"
          identifiers = [data.aws_redshift_service_account.main.arn]
        }

        actions   = ["s3:PutObject"]
        resources = ["${aws_s3_bucket.redshift_logging_bucket.arn}/*"]
      }

      statement {
        # sid    = "Get bucket policy needed for audit logging"
        effect = "Allow"

        principals {
          type = "AWS"
          identifiers = [
            data.aws_redshift_service_account.main.arn,
          ]
        }

        actions   = ["s3:GetBucketAcl"]
        resources = [aws_s3_bucket.redshift_logging_bucket.arn]
      }
    }

### S3 bucket policy reference
https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-policy-language-overview.html

# AWS EKS
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

# AWS EMR
## EMR submit a test file
### copy the test file to your bucket
    aws s3 cp s3://us-east-1.elasticmapreduce/emr-containers/samples/wordcount/scripts/wordcount.py s3://{your-bucket-name}/scripts/ --region us-east-1

### submit your spark job to cluster
    aws emr-serverless start-job-run --application-id {your-application-id} --execution-role-arn {your-emr-role-arn} --name "spark-test" --job-driver '{"sparkSubmit":{"entryPoint":"s3://{your-bucket-name}/scripts/wordcount.py", "entryPointArguments":["s3://{your-bucket-name}/output"], "sparkSubmitParameters": "--conf spark.executor.cores=1 --conf spark.executor.memory=4g --conf spark.driver.cores=1 --conf spark.driver.memory=4g --conf spark.executor.instances=1"}}' --region {your-region}
    
### EMR serverless reference
1. **using terraform** <br> 
https://github.com/terraform-aws-modules/terraform-aws-emr/tree/v1.0.0/examples/serverless-cluster <br>
2. **EMR serverless iam role & submit config** <br>
https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/jobs-spark.html <br>
3. **Use Python packages** <br>
https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html <br>

# AWS redshift
## Time zone
You can't set the timezone configuration parameter by using a cluster parameter group. The time zone can be set only for the current session by using a SET command. To set the time zone for all sessions run by a specific database user, use the ALTER USER command. ALTER USER … SET TIMEZONE changes the time zone for subsequent sessions, not for the current session.
https://docs.aws.amazon.com/redshift/latest/dg/r_timezone_config.html

## AWS redshift parameter group & configuration
https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html <br>
https://docs.aws.amazon.com/redshift/latest/dg/cm_chap_ConfigurationRef.html

## AWS redshift distribution styles
https://docs.aws.amazon.com/redshift/latest/dg/c_choosing_dist_sort.html

## AWS redshift query editor v2 reference
https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_how-services-use-secrets_sqlworkbench.html

# AWS secret manager 
## AWS secret manager - get secret in your App
    import boto3
    from botocore.exceptions import ClientError


    def get_secret():

        secret_name = "data/prod/redshift"
        region_name = "us-east-2"

        # Create a Secrets Manager client
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        try:
            get_secret_value_response = client.get_secret_value(
                SecretId=secret_name
            )
        except ClientError as e:
            # For a list of exceptions thrown, see
            # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
            raise e

        # Decrypts secret using the associated KMS key.
        secret = get_secret_value_response['SecretString']

        # Your code goes here.


### AWS secret manager reference
https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html <br>
https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1

# reference
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/RootDeviceStorage.html <br>
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks <br>
https://aws.github.io/aws-eks-best-practices/networking/subnets/ <br>
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group <br>
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group <br>


