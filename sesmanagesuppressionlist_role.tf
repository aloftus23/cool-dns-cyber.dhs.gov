# ------------------------------------------------------------------------------
# Create the IAM policy that allows management of the AWS SES
# suppression list.
# ------------------------------------------------------------------------------

# An IAM policy document that allows the users account to assume the
# role.
data "aws_iam_policy_document" "sesmanagesuppressionlist_assume_role_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      identifiers = [
        local.users_account_id,
      ]
      type = "AWS"
    }
  }
}

resource "aws_iam_role" "sesmanagesuppressionlist_role" {
  provider = aws.dnsprovisionaccount

  assume_role_policy = data.aws_iam_policy_document.sesmanagesuppressionlist_assume_role_doc.json
  description        = var.sesmanagesuppressionlist_role_description
  name               = var.sesmanagesuppressionlist_role_name
}

resource "aws_iam_role_policy_attachment" "sesmanagesuppressionlist_policy_attachment" {
  provider = aws.dnsprovisionaccount

  policy_arn = aws_iam_policy.sesmanagesuppressionlist_policy.arn
  role       = aws_iam_role.sesmanagesuppressionlist_role.name
}
