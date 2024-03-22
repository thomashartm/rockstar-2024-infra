data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "power_user_role" {
  name                 = "${var.stage}-${var.stack}-poweruser-role"
  description          = "Connection to account resources"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "developer_write" {
  role   = aws_iam_role.power_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
