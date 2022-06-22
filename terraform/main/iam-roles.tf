### Frontend
data "aws_iam_policy_document" "ghost" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ghost" {
  statement {
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      aws_s3_bucket.ghost_backup.arn,
      "${aws_s3_bucket.ghost_backup.arn}/*",
    ]
  }
}

resource "aws_iam_role" "ux2play_instance_role" {
  name = "ghost-role"

  assume_role_policy = data.aws_iam_policy_document.ghost.json
}

resource "aws_iam_role_policy" "ux2play_instance_policy" {
  name = "ux2play-instance-policy"
  role = aws_iam_role.ux2play_instance_role.id

  policy = data.aws_iam_policy_document.ghost.json
}

### Processing
data "aws_iam_policy_document" "ux2play_processing_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }

    effect = "Allow"
  }
}
