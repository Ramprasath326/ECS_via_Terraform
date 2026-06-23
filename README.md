# ECS Fargate Infrastructure with Terraform

A complete, modular AWS infrastructure project provisioning a production-style **ECS Fargate** application stack using **Terraform** — built as a hands-on capstone to demonstrate real-world infrastructure-as-code practices, including remote state management, multi-tier networking, and least-privilege IAM design.

## Architecture

```
                              Internet
                                 │
                          ┌──────▼──────┐
                          │     ALB     │  (public subnets)
                          └──────┬──────┘
                                 │
                          ┌──────▼──────┐
                          │ Target Group│
                          └──────┬──────┘
                                 │
        ┌────────────────────────────────────────────┐
        │              ECS Fargate Service             │
        │         (private subnets, 2 AZs)              │
        │  ┌──────────────┐      ┌──────────────┐      │
        │  │   Task (AZ-a) │      │  Task (AZ-b) │      │
        │  └──────────────┘      └──────────────┘      │
        └────────────────────────────────────────────┘
                                 │
                          ┌──────▼──────┐
                          │  NAT Gateway │ → ECR / CloudWatch
                          └─────────────┘
```

**Traffic flow:** Internet → ALB (public subnets, port 80) → Target Group → ECS Fargate tasks (private subnets) → container (nginx, port 80). Outbound calls from tasks (e.g., pulling images from ECR, writing logs) route through a NAT Gateway sitting in the public subnet.

## What this provisions

- **Networking** — Custom VPC, 2 public + 2 private subnets across 2 Availability Zones, Internet Gateway, NAT Gateway, route tables, and associations
- **Security** — Tiered security groups (`web_sg` for the ALB, `api_sg` for ECS tasks), using SG-to-SG referencing instead of broad CIDR rules where appropriate
- **Load Balancing** — Application Load Balancer, target group, and HTTP listener
- **Compute** — ECS Cluster, Fargate Task Definition, and ECS Service (desired count: 2, spread across both AZs)
- **Container Registry** — ECR repository with image scanning on push
- **IAM** — Separate Task Execution Role (image pull, log writes) and Task Role (application-level permissions), following least-privilege principles
- **Observability** — CloudWatch Log Group for container logs
- **Remote State** — S3 backend with DynamoDB state locking, managed as an isolated bootstrap project

## Project structure

```
.
├── app/
│   └── Dockerfile              # Test container (nginx)
├── modules/
│   ├── vpc/                    # VPC, subnets, IGW, NAT, route tables
│   ├── sg/                     # Security groups
│   └── alb/                    # Load balancer, target group, listener
├── backend.tf                  # Remote state configuration (S3 + DynamoDB)
├── ecr.tf                      # Container registry
├── iam_roles.tf                # Task execution & task roles
├── ecs_cluster.tf              # ECS cluster
├── ecs_service.tf              # ECS service & task definition
├── main.tf                     # Module composition
├── outputs.tf                  # Root-level outputs
├── variables.tf                # Root-level variable declarations
└── terraform.tfvars            # Variable values (gitignored)
```

**Design note on modularization:** `vpc`, `sg`, and `alb` are split into reusable modules since they represent independently meaningful infrastructure. ECR, IAM roles, and the ECS cluster/service are kept at root level — they're tightly coupled to this specific application rather than independently reusable, so wrapping them in modules would add indirection without a real benefit.

## Remote state

State is stored in S3 with DynamoDB locking, managed via a **separate bootstrap project** (not included in this repo) that owns the state bucket and lock table independently. This avoids a circular dependency where the working project's `terraform destroy` could accidentally tear down its own state storage.

## Prerequisites

- Terraform >= 1.9
- AWS CLI, configured with credentials
- Docker (for building/pushing the container image)
- An existing S3 bucket + DynamoDB table for remote state (see `backend.tf` for expected naming)

## Usage

```bash
# Initialize and review
terraform init
terraform plan

# Provision infrastructure
terraform apply

# Build and push the container image
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
docker build -t <repo-name> ./app
docker tag <repo-name>:latest <account-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>:latest
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>:latest

# Force ECS to pick up the new image
aws ecs update-service --cluster <cluster-name> --service <service-name> --force-new-deployment

# Get the ALB URL
terraform output alb_dns_name

# Tear down
terraform destroy
```

## Key engineering decisions

- **Private subnets for compute** — ECS tasks are not directly internet-facing; only the ALB sits in public subnets, with NAT Gateway providing controlled outbound access for image pulls and logging.
- **Two separate IAM roles** — the Task Execution Role (AWS-managed, used by ECS infrastructure) is kept distinct from the Task Role (scoped to whatever permissions the application itself needs), rather than over-granting a single combined role.
- **SG-to-SG referencing** — internal service-to-service rules reference security group IDs rather than CIDR blocks, so access automatically follows the resources behind a tier instead of requiring manual IP tracking.
- **`force_delete` on ECR** — enabled deliberately for this disposable practice environment to support fast iterate/destroy cycles; would be removed for a production registry.

## Roadmap

- [ ] GitHub Actions CI/CD pipeline: build → push to ECR → `terraform apply` → force ECS deployment, triggered on push
- [ ] HTTPS listener (ACM certificate + port 443)
- [ ] Auto scaling policy for the ECS service

## Author

Built by Ram as a hands-on capstone covering Terraform fundamentals through a production-style multi-tier AWS deployment — state management, modules, networking, security, IAM, and container orchestration.
