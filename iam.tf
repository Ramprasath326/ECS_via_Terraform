#Task execution role - Used by ECS agent to pull images and push logs

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-task-execution-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }]
    }
  )
  tags = {
    name = "${var.project_name}-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Task Role - Used by the Container itself to call aws services

resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-task-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }]
    }

  )

  tags = {
    name = "${var.project_name}-task-execution-role"

  }
}