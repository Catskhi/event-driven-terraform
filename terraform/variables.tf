variable "project_name" {
  description = "The project name"
  type = string
  default = "tasks-api"
}

variable "environment" {
    description = "The deployment environment (e.g., dev, staging, prod)"
    type        = string
    default     = "dev"
  
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}