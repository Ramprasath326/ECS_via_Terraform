resource "aws_ecs_service" "app-service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "app-container"
    container_port   = 80
  }

  network_configuration {
    subnets         = module.vpc.private_subnet_ids
    security_groups = [module.sg.api_sg_id]
    assign_public_ip = false
  }

  depends_on = [module.alb.alb_listener_arn]
}