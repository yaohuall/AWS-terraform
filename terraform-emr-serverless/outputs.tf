output "application_name" {
  value       = aws_emrserverless_application.app.name
  description = "Name of the EMR Serverless application"
}

output "application_id" {
  value       = aws_emrserverless_application.app.id
  description = "Id of the EMR Serverless application"
}

output "emr_network_config" {
  description = "EMR network config"
  value       = aws_emrserverless_application.app.network_configuration
}

output "spark_serverless_jobrun_role_arn" {
  description = "Amazon Resource Name (ARN) specifying the spark job role."
  value       = aws_iam_role.spark-serverless-jobrun-role.arn
}

# output "spark_id" {
#   description = "ID of the application"
#   value       = module.emr_serverless_spark.id
# }

# output "spark_arn" {
#   description = "Amazon Resource Name (ARN) of the application"
#   value       = module.emr_serverless_spark.arn
# }
