# Description

Terraform module to trigger the codepipeline via events, instead of polling.

## Usage

Refer as in https://developer.hashicorp.com/terraform/language/modules/sources

resources.tf

``` terraform
module "codepipeline-event-trigger" {
  source                = "github.com/alfrepo/terraform_module_codepipeline-event-trigger"
  aws_region            = local.aws_region
  aws_account_id        = local.aws_account_id
  prefix                = local.prefix
  repository_name       = local.repository_name
  repository_arn        = local.repository_arn
  repository_branch     = local.repository_branch
  app_codepipeline_arn  = module.webserver-pipeline.app_codepipeline_arn // pass aour codepipeline arn here
}

```

and you locals definition:

variables.tf

``` terraform
locals {
  aws_region        = "eu-central-1"                // region
  aws_account_id    = "123412341234"
  prefix            = "myprefix-dev-env1"           // my deployment namespace
  repository_name   = "MyGitRepoToListenForCommits" // The repo name
  repository_arn    = "arn:aws:codecommit:eu-central-1:123412341234:MyGitRepoToListenForCommits"
  repository_branch = "master"
}
```
