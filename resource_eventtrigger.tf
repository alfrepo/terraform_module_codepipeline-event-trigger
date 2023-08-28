# REPLACE POLLING OF PIPELINE BY EVENTS

# Listen for activity on the CodeCommit repo and trigger the CodePipeline
resource "aws_cloudwatch_event_rule" "codecommit_activity" {
  description = "Detect commits to CodeCommit repo of ${var.repository_name}"

  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": [ "${var.repository_arn}" ],
  "detail": {
     "event": [
       "referenceCreated",
       "referenceUpdated"
      ],
     "referenceType":["branch"],
     "referenceName": ["${var.repository_branch}"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch_triggers_pipeline" {
  target_id = "${var.repository_name}-commits-trigger-pipeline"
  rule = aws_cloudwatch_event_rule.codecommit_activity.name
  arn = var.app_codepipeline_arn
  role_arn = aws_iam_role.cloudwatch_ci_role.arn
}

# Allows the CloudWatch event to assume roles
resource "aws_iam_role" "cloudwatch_ci_role" {
  name_prefix = "${var.prefix}"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}
data "aws_iam_policy_document" "cloudwatch_ci_iam_policy" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    # Allow CloudWatch to start the Pipeline
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = [
      var.app_codepipeline_arn
    ]
  }
}
resource "aws_iam_policy" "cloudwatch_ci_iam_policy" {
  name_prefix = "${var.prefix}"
  policy = data.aws_iam_policy_document.cloudwatch_ci_iam_policy.json
}
resource "aws_iam_role_policy_attachment" "cloudwatch_ci_iam" {
  policy_arn = aws_iam_policy.cloudwatch_ci_iam_policy.arn
  role = aws_iam_role.cloudwatch_ci_role.name
}