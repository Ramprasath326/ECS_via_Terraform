#Cloudwatch log group forr nginx container logs
resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/ecs/${var.project_name}-nginx-logs"
  retention_in_days = 7
  tags = {
    Name = "${var.project_name}-nginx-logs"
  }
}

#ECS cluster

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
  tags = {
    Name = "${var.project_name}-cluster"
  }
}

#Task definition - blueprint for your container
resource "aws_ecs_task_definition" "nginx" {
  family                   = "${var.project_name}-nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode(
    [
      {
        name      = "nginx"
        image     = "${aws_ecr_repository.nginx.repository_url}:latest"
        essential = true

        portMappings = [{
          ContainerPort = 80
          protocol      = "tcp"
        }]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.nginx.name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "nginx"
          }
        }
      }
    ]
  )
  tags = {
    Name = "${var.project_name}-nginx-td"
  }

}

#ECS service - keeps desired number of tasks running
resource "aws_ecs_service" "nginx" {
  name            = "${var.project_name}-nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx.arn
    container_name   = "nginx"
    container_port   = 80
  }
  depends_on = [aws_lb_listener.http]
  tags = {
    Name = "${var.project_name}-nginx-service"
  }
}