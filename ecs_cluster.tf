# Create an ECS Cluster
resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
}

# CloudWatch Logs for ECS
resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name = "ecs-log-group"
}

#creating task definition
resource "aws_ecs_task_definition" "app-task" {
  family                   = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn   
  task_role_arn            = aws_iam_role.task_role.arn             
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image = "${aws_ecr_repository.my_ecr_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
        logConfiguration = {
            logDriver = "awslogs"
            options = {
            "awslogs-group"         = aws_cloudwatch_log_group.ecs-log-group.name
            "awslogs-region"        = "us-east-1"
            "awslogs-stream-prefix" = "ecs"
            }
        }
    }
  ])
}
