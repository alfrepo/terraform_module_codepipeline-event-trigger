variable "aws_region" {
  description = "The AWS region to deploy the resources into"
  type = string
}

variable "aws_account_id" {
  description = "The AWS account identifier of the project"
  type = string
}


variable "prefix" {
  description = "The resource prefix"
  type = string
}

variable "repository_name" {
  description = "The email for GIT"
  type = string
}

variable "repository_arn" {
  description = "The arn of the repository"
  type = string
}

variable "repository_branch" {
  description = "The git branch to listen to"
  type = string
}

variable "app_codepipeline_arn" {
  description = "The ARN of the pipeline"
  type = string
}

