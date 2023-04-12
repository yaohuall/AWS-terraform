resource "aws_emrserverless_application" "app" {
    name          = "spark-serverless"
    release_label = "emr-6.6.0"
    type          = "spark"

    # total cpu and memory used in the application
    maximum_capacity {
        cpu    = "4 vCPU"
        memory = "16 GB"
    }

    initial_capacity {
        initial_capacity_type = "Driver"

        initial_capacity_config {
            worker_count = 1
            worker_configuration {
                cpu    = "1 vCPU"
                memory = "8 GB"
            }
        }
    }

  auto_start_configuration {
    # defaults
    enabled = "true"
  }

  auto_stop_configuration {
    # defaults
    enabled              = "true"
    idle_timeout_minutes = 15
  }

  network_configuration {
    security_group_ids = [aws_security_group.spark-serverless.id]
    subnet_ids         = [aws_subnet.private_us_east_2a.id]
  }
  tags = {
    Name = "spark-serverless"
  }
}