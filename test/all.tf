provider "aws" {
  access_key = "foo"
  secret_key = "bar"
  region     = "us-east-1"
}

data "aws_iam_policy_document" "all" {

  policy_id = "BasicPolicy"

  statement {

    sid = "Stmt1456535218000"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]

    resources = ["*"]

  }

  statement {

    sid = "Stmt1456535243000"
    effect = "Allow"

    actions = [
      "cloudwatch:DescribeAlarms"
    ]

    resources = [
      "arn:aws:s3:::BUCKET-NAME/home/x",
      "arn:aws:s3:::BUCKET-NAME/home/x/*"
    ]

    condition {
      test = "DateGreaterThan"
      variable = "aws:CurrentTime"
      values = [
        "2013-08-16T12:00:00Z"
      ]
    }

    condition {
      test = "DateLessThan"
      variable = "aws:CurrentTime"
      values = [
        "2013-08-16T15:00:00Z"
      ]
    }

    condition {
      test = "DateGreaterThan"
      variable = "aws:SourceIp"
      values = [
        "192.0.2.0/24",
        "203.0.113.0/24"
      ]
    }

  }

  statement {

    sid = "PrincipalThingy"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]

  }

  statement {

    sid = "PrincipalStars"
    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "sts:AssumeRole"
    ]

  }
}
