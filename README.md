# iam2tf

### Synopsis

Converts AWS IAM policies into Terraform's `aws_iam_policy_document` format.

### Usage

Given a JSON IAM policy document on stdin, it will produce an equivalent terraform document on stdout:

```shell
$ ruby iam2tf.rb < example.json
```

#### Example Output

```terraform
data "aws_iam_policy_document" "iam2tf" {

  statement {
    sid    = ""
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }

  }

}
```

#### Example Input

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

##### Running Tests

Current status: better than nothing.

```bash
for i in test/*.json; do echo $i; ruby iam2tf.rb < $i || break; done
```

#### References

 * [Terraform IAM Policy Document](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)
 * [IAM Policy Grammer](http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_grammar.html)
